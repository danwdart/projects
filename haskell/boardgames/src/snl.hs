{-# LANGUAGE DeriveAnyClass       #-}
{-# LANGUAGE DerivingStrategies   #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE TypeFamilies         #-}
{-# LANGUAGE UndecidableInstances #-}

module Main (main) where

import Control.Exception
import Control.Lens
-- import Control.Monad.IO.Class
import Control.Monad.Except
-- import Control.Monad.Fail
-- import Control.Monad.State
import Control.Monad.Random
-- import Control.Monad.Reader
-- import Control.Monad.Writer
import Control.Monad.RWS
-- import Data.Aeson qualified as A
import Data.List            qualified as L
import Data.List.NonEmpty   qualified as NE
import Data.Map             (Map)
import Data.Map             qualified as M
import Data.Ratio
-- import Data.Yaml qualified as Y
import System.Console.ANSI

-- Enums
data RolloverStrategy = Exact | Reverse | Rebirth | Gimme
    deriving stock (Bounded, Enum, Eq, Show)

data AppError = CantFindPlayer Int
    deriving stock (Show)
    deriving anyclass (Exception)

-- Datatypes

data BoardDimensions = BoardDimensions {
    _start :: Int,
    _stop  :: Int
} deriving stock (Eq, Show)

$(makeClassy ''BoardDimensions)

newtype Space = Space {
    _getSpace :: Int
} deriving newtype (Eq, Show)

makeWrapped ''Space

newtype FromSpace = FromSpace {
    _getFromSpace :: Int
} deriving newtype (Eq, Ord, Show)

makeWrapped ''FromSpace

newtype ToSpace = ToSpace {
    _getToSpace :: Int
} deriving newtype (Eq, Ord, Show)

makeWrapped ''ToSpace

newtype Teleports = Teleports {
    _getTeleports :: Map FromSpace ToSpace
} deriving newtype (Eq, Ord, Show)

makeWrapped ''Teleports

newtype NumPlayers = NumPlayers {
    _getNumPlayers :: Int
} deriving newtype (Eq, Show)

makeWrapped ''NumPlayers

data GameBoard = GameBoard {
    _dimensions :: BoardDimensions,
    _teleports  :: Teleports
} deriving stock (Eq, Show)

$(makeClassy ''GameBoard)

-- Get around classy duplicates (requires undecidable instances)

instance HasGameBoard r ⇒ HasBoardDimensions r where
    boardDimensions = dimensions

newtype DiffSpace = DiffSpace {
    _getDiffSpace :: Int
} deriving newtype (Eq, Ord, Show)

makeWrapped ''DiffSpace

newtype MoveProbabilities = MoveProbabilities {
    _getMoveProbabilities :: Map DiffSpace Rational
} deriving newtype (Eq, Show)

makeWrapped ''MoveProbabilities

data Ruleset = Ruleset {
    _rolloverStrategy  :: RolloverStrategy,
    _moveProbabilities :: MoveProbabilities,
    _numPlayers        :: NumPlayers
} deriving stock (Eq, Show)

$(makeClassy ''Ruleset)

data Game = Game {
    _board :: GameBoard,
    _rules :: Ruleset
} deriving stock (Eq, Show)

$(makeClassy ''Game)

-- Get around classy duplicates (requires undecidable instances)
instance HasGame r ⇒ HasGameBoard r where
    gameBoard = board

instance HasGame r ⇒ HasRuleset r where
    ruleset = rules

-- @TODO validation
data Player = Player {
    _name  :: String,
    _space :: Space
} deriving stock (Eq, Show)

$(makeClassy ''Player)

{-}
newtype PlayerTurn = PlayerTurn {
    getPlayerTurn :: Int
} deriving newtype (Eq, Show)
-}

data GameState = GameState {
    _players    :: NE.NonEmpty Player,
    _playerTurn :: Int,
    _turns      :: Int
} deriving stock (Eq, Show)

$(makeClassy ''GameState)

-- Helper functions

hasWon ∷ Int → Player → Bool
hasWon finishingSpace player' = (player' ^. (space . _Wrapped)) == finishingSpace

coloured ∷ Color → String → String
coloured colour = (setSGRCode [SetColor Foreground Vivid colour] <>) . (<> setSGRCode [Reset])

getMaybeWinner ∷ (MonadWriter [String] m, MonadReader r m, HasBoardDimensions r, MonadState s m, HasGameState s) ⇒ m (Maybe Player)
getMaybeWinner = do
    let fn = coloured Red "getMaybeWinner"
    tell [fn <> ": Is there a winner?"]
    finishingSpace <- view stop -- fix asks
    players' <- use players
    let mPlayer = L.find (hasWon finishingSpace) players'
    case mPlayer of
        Nothing      -> tell [fn <> ": No winner yet."]
        Just player' -> tell [fn <> ": The winner is: " <> show player']
    pure mPlayer

getRandomByFrequencies ∷ (MonadWriter [String] m, MonadRandom m, Show a) ⇒ Map a Rational → m a
getRandomByFrequencies weights = do
    let fn = coloured Yellow "getRandomByFrequencies"
    roll' <- weighted (M.toList weights)
    tell [fn <> ": Rolled a " <> show roll']
    pure roll'

movePlayerToPosition ∷ (MonadWriter [String] m, MonadState s m, HasGameState s) ⇒ Space → m ()
movePlayerToPosition space' = do
    let fn = coloured Green "movePlayerToPosition"
    playerIndex <- use playerTurn
    tell [fn <> ": Moving player " <> show playerIndex <> " to space " <> show space' <> "."]
    players . element playerIndex . space .= space'

movePlayerBy ∷ (MonadWriter [String] m, MonadState s m, HasGameState s) ⇒ DiffSpace → m ()
movePlayerBy (DiffSpace spaces) = do
    let fn = coloured Green "movePlayerBy"
    playerIndex <- use playerTurn
    tell [fn <> ": Moving player " <> show playerIndex <> " by " <> show spaces <> " spaces."]
    players . element playerIndex . space . _Wrapped += spaces

performTeleportation ∷ (MonadWriter [String] m, MonadError AppError m, MonadReader r m, HasGameBoard r, MonadState s m, HasGameState s) ⇒ m ()
performTeleportation = do
    let fn = coloured Cyan "performTeleportation"
    teleports' <- view $ teleports . _Wrapped
    playerIndex <- use playerTurn
    mPlayer <- preuse $ players . element playerIndex
    case mPlayer of
        Nothing -> throwError $ CantFindPlayer playerIndex
        Just player' -> do
            let currentSpace = player' ^. (space . _Wrapped)
            tell [fn <> ": current space is " <> show currentSpace]
            case M.lookup (FromSpace currentSpace) teleports' of
                Just (ToSpace space') -> do
                    tell [fn <> ": It was a teleport to " <> show space']
                    players . element playerIndex . space . _Wrapped .= space'
                    currentSpace' <- preuse (players . element playerIndex . space)
                    tell [fn <> ": Cool. We are now at " <> show currentSpace']
                Nothing -> do
                    tell [fn <> ": It was not a teleport."]

performRollover ∷ (MonadWriter [String] m, MonadError AppError m, MonadReader r m, HasRuleset r, HasBoardDimensions r, MonadState s m, HasGameState s) ⇒ m ()
performRollover = do
    let fn = coloured Magenta "performRollover"
    rolloverStrategy' <- view rolloverStrategy
    playerIndex <- use playerTurn
    mPlayer <- preuse $ players . element playerIndex
    case mPlayer of
        Nothing -> throwError $ CantFindPlayer playerIndex
        Just player' -> do
            let currentSpace = player' ^. (space . _Wrapped)
            tell [fn <> ": current space is " <> show currentSpace]
            finishingSpace <- view stop
            startingSpace <- view start
            let overflow = currentSpace - finishingSpace
            when (overflow > 0) $ do -- @TODO k ()
                tell [fn <> ": Looks like there's a rollover to manage."]
                case rolloverStrategy' of
                    Exact -> pure () -- @TODO check what the roll was!
                    Reverse -> do
                        let newSpace = finishingSpace - overflow
                        tell [fn <> ": Gone off the end, reversing from the end by " <> show overflow <> " to " <> show newSpace]
                        movePlayerToPosition $ Space newSpace
                    Rebirth -> do
                        let newSpace = startingSpace + overflow
                        tell [fn <> ": Gone off the end by " <> show overflow <> " so rebirthing to " <> show newSpace]
                        movePlayerToPosition $ Space newSpace
                    Gimme -> do
                        tell [fn <> ": Gimme!"]
                        movePlayerToPosition $ Space finishingSpace

nextPlayer ∷ (MonadWriter [String] m, MonadError AppError m, MonadReader r m, HasRuleset r, MonadState s m, HasGameState s) ⇒ m ()
nextPlayer = do
    let fn = coloured Green "nextPlayer"
    numPlayers' <- view $ numPlayers . _Wrapped
    currentPlayer <- use playerTurn
    mPlayer <- preuse $ players . element currentPlayer
    case mPlayer of
        Nothing -> throwError $ CantFindPlayer currentPlayer
        Just player' -> do
            tell [fn <> ": Current player is " <> show currentPlayer <> ", which is " <> player' ^. name]
            playerTurn %= ((`mod` numPlayers') . succ)
            newPlayer <- use playerTurn
            mPlayer' <- preuse $ players . element newPlayer
            case mPlayer' of
                Nothing -> throwError $ CantFindPlayer currentPlayer
                Just player'' -> do
                    tell [fn <> ": Next player is player " <> show newPlayer <> ", which is " <> player'' ^. name]

roll ∷ (MonadWriter [String] m, MonadRandom m, MonadReader r m, HasRuleset r, MonadState s m, HasGameState s) ⇒ m ()
roll = do
    let fn = coloured Red "roll"
    moveProbabilities' <- view $ moveProbabilities . _Wrapped
    randomRoll <- getRandomByFrequencies moveProbabilities'
    tell [fn <> ": Moving player by " <> show randomRoll]
    movePlayerBy randomRoll

turn ∷ (MonadWriter [String] m, MonadRandom m, MonadError AppError m, MonadReader r m, HasRuleset r, HasBoardDimensions r, HasGameBoard r, MonadState s m, HasGameState s) ⇒ m ()
turn = do
    let fn = coloured Blue "turn"
    -- Get the player number
    tell [fn <> ": Rolling."]
    roll
    tell [fn <> ": Performing rollover."]
    performRollover
    tell [fn <> ": Performing teleportation."]
    performTeleportation
    tell [fn <> ": Next player!"]
    nextPlayer
    turns += 1
    pure ()

-- Main playing function

playUntilWinner ∷ (MonadWriter [String] m, MonadRandom m, MonadError AppError m, MonadReader r m, HasGame r, HasGameBoard r, HasBoardDimensions r, HasRuleset r, MonadState s m, HasGameState s) ⇒ m Player
playUntilWinner = do
    let fn = coloured Yellow "playUntilWinner"
    tell [fn <> ": making a turn."]
    turn
    maybeWinner <- getMaybeWinner
    case maybeWinner of
        Nothing -> do
            tell [fn <> ": No winner yet,"]
            playUntilWinner
        Just winner -> do
            tell [fn <> ": The winner is: " <> show winner]
            pure winner

-- Sample boards (@TODO: move into encoded files)

-- https://www.pinterest.com.au/pin/647744358880178687/
board1 ∷ GameBoard
board1 = GameBoard (BoardDimensions 1 100) (Teleports (M.fromList [
    (FromSpace 1, ToSpace 38),
    (FromSpace 4, ToSpace 14),
    (FromSpace 9, ToSpace 31),
    (FromSpace 17, ToSpace 7),
    (FromSpace 21, ToSpace 42),
    (FromSpace 28, ToSpace 84),
    (FromSpace 51, ToSpace 67),
    (FromSpace 54, ToSpace 34),
    (FromSpace 62, ToSpace 19),
    (FromSpace 64, ToSpace 60),
    (FromSpace 72, ToSpace 91),
    (FromSpace 80, ToSpace 99),
    (FromSpace 87, ToSpace 36),
    (FromSpace 93, ToSpace 73),
    (FromSpace 95, ToSpace 75),
    (FromSpace 98, ToSpace 79)
    ]))

-- https://youtu.be/nlm07asSU0c?si=xNttuEZVg4j-0osV&t=132
{-}
numberphileBoard :: Board
numberphileBoard = Board (BoardDimensions 1 64) (Teleports (M.fromList [
    (FromSpace 7, ToSpace 22),
    (FromSpace 8, ToSpace 40),
    (FromSpace 13, ToSpace 56),
    (FromSpace 14, ToSpace 47),
    (FromSpace 23, ToSpace 4),
    (FromSpace 30, ToSpace 10),
    (FromSpace 35, ToSpace 60),
    (FromSpace 42, ToSpace 9),
    (FromSpace 49, ToSpace 15),
    (FromSpace 54, ToSpace 20),
    (FromSpace 61, ToSpace 46)
    ]))
-}

-- https://youtu.be/nlm07asSU0c?si=6GovGJrNlNhKaUYg&t=237
{-}
duSautoyBoard :: Board
duSautoyBoard = Board (BoardDimensions 0 10) (Teleports (M.fromList [
    (FromSpace 4, ToSpace 7),
    (FromSpace 8, ToSpace 2)
    ]))
-}

-- Sample rulesets (move into encoded files)

fairD6 ∷ MoveProbabilities
fairD6 = MoveProbabilities . M.fromList . zip (DiffSpace <$> [1..]) . replicate 6 $ (1 % 6)

normalRules ∷ Ruleset
normalRules = Ruleset Reverse fairD6 (NumPlayers 2)

initialGame ∷ Game
initialGame = Game {
    _board = board1,
    _rules = normalRules
}

initialState ∷ GameState
initialState = GameState {
    _players = NE.fromList [
        Player {
            _name = "Bob",
            _space = Space 1
        },
        Player {
            _name = "Jim",
            _space = Space 1
        }
        ],
    _playerTurn = 0,
    _turns = 0
}


-- File I/O

-- @TODO: split by format

{-}
class MonadFail m => MonadFile a m where
    save :: FilePath -> a -> m ()
    load :: FilePath -> m a
-}

{-}
squash :: (MonadFail m1, MonadIO m2, MonadFail n, MonadIO n) => m1 (m2 a) -> n a
squash = _
-}

-- instance (A.FromJSON a, A.ToJSON a, MonadIO m, MonadFail m) => MonadFile a m where

{-}
@TODO fix this
instance (A.FromJSON a, A.ToJSON a, MonadIO m, MonadFail m) => MonadFile a m where
    save f a = ExceptT . liftIO . Right <$>  A.encodeFile f a
    load f = ExceptT (liftIO (A.eitherDecodeFileStrict f)
-}

-- How do you even choose this?
-- TODO: binary, protobuf
{-
instance (FromJSON a, ToJSON a, MonadIO m, MonadFail m) => MonadFile a m where
    save = Y.encodeFile
    load = Y.decodeFile
-}

-- Main I/O interface
-- argv: gameboard, ruleset, number of players (names maybe) or --ruleset-option=X

main ∷ IO ()
main = do
    result <- runExceptT $ do
        (winner, endingGameState, writeStream) <- runRWST playUntilWinner initialGame initialState
        mapM_ (liftIO . putStrLn) writeStream
        liftIO .putStrLn $ "The winner is: " <> winner ^. name <> "! Winning space: " <> show (winner ^. space) <> ". Took " <> show (endingGameState ^. turns) <> " turns."
        liftIO . print $ endingGameState
    case result of
        Left err -> print err
        Right () -> pure ()

-- @TODO average, space per colour
-- @TODO monadwriter with colours and for each function, add state for spacing
