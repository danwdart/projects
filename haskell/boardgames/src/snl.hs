{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE TemplateHaskell #-}

module Main (main) where

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
import Data.List qualified as L
import Data.Map (Map)
import Data.Map qualified as M
import Data.Ratio
-- import Data.Yaml qualified as Y
import System.Console.ANSI

-- Datatypes

data BoardDimensions = BoardDimensions {
    _start :: Int,
    _stop  :: Int
} deriving stock (Eq, Show)

$(makeLenses ''BoardDimensions)

newtype Space = Space {
    getSpace :: Int
} deriving newtype (Eq, Show)

newtype FromSpace = FromSpace {
    _getFromSpace :: Int
} deriving newtype (Eq, Ord, Show)

newtype ToSpace = ToSpace {
    _getToSpace :: Int
} deriving newtype (Eq, Ord, Show)

newtype Teleports = Teleports {
    getTeleports :: Map FromSpace ToSpace
} deriving newtype (Eq, Ord, Show)

newtype NumPlayers = NumPlayers {
    getNumPlayers :: Int
} deriving newtype (Eq, Show)

data Board = Board {
    _boardDimensions  :: BoardDimensions,
    _teleports        :: Teleports
} deriving stock (Eq, Show)

$(makeLenses ''Board)

data RolloverStrategy = Exact | Reverse | Rebirth | Gimme
    deriving stock (Eq, Show)

newtype MoveProbabilities = MoveProbabilities {
    getMoveProbabilities :: Map DiffSpace Rational
} deriving newtype (Eq, Show)

newtype DiffSpace = DiffSpace {
    _getDiffSpace :: Int
} deriving newtype (Eq, Ord, Show)

data Ruleset = Ruleset {
    _rolloverStrategy :: RolloverStrategy,
    _moveProbabilities :: MoveProbabilities,
    _numPlayers :: NumPlayers
} deriving stock (Eq, Show)

$(makeLenses ''Ruleset)

data Game = Game {
    _board :: Board,
    _ruleset :: Ruleset
} deriving stock (Eq, Show)

$(makeLenses ''Game)

-- @TODO validation
data Player = Player {
    _name  :: String,
    _space :: Space
} deriving stock (Eq, Show)

$(makeLenses ''Player)

{-}
newtype PlayerTurn = PlayerTurn {
    getPlayerTurn :: Int
} deriving newtype (Eq, Show)
-}

data GameState = GameState {
    _players    :: [Player],
    _playerTurn :: Int,
    _turns :: Int
} deriving stock (Eq, Show)

$(makeLenses ''GameState)

-- Helper functions

hasWon :: Int -> Player -> Bool
hasWon finishingSpace player = getSpace (player ^. space) == finishingSpace

coloured :: Color -> String -> String
coloured colour str = setSGRCode [SetColor Foreground Vivid colour] <> str <> setSGRCode [Reset]

getMaybeWinner :: (MonadWriter [String] m, MonadReader Game m, MonadState GameState m) => m (Maybe Player)
getMaybeWinner = do
    let fn = coloured Red "getMaybeWinner"
    tell [fn <> ": Is there a winner?"]
    finishingSpace <- view $ board . boardDimensions . stop -- fix asks
    players' <- use players
    let mPlayer = L.find (hasWon finishingSpace) players'
    case mPlayer of
        Nothing -> tell [fn <> ": No winner yet."]
        Just player -> tell [fn <> ": The winner is: " <> show player]
    pure $ mPlayer

-- We're going to need some lenses!

getRandomByFrequencies :: (MonadWriter [String] m, MonadRandom m, Show a) => Map a Rational -> m a
getRandomByFrequencies weights = do
    let fn = coloured Yellow "getRandomByFrequencies"
    roll' <- weighted (M.toList weights)
    tell [fn <> ": Rolled a " <> show roll']
    pure roll'

movePlayerToPosition :: (MonadWriter [String] m, MonadState GameState m) => Space -> m ()
movePlayerToPosition space' = do
    let fn = coloured Green "movePlayerToPosition"
    playerIndex <- use playerTurn
    tell [fn <> ": Moving player " <> show playerIndex <> " to space " <> show space' <> "."]
    players . element playerIndex . space .= space'

movePlayerBy :: (MonadWriter [String] m, MonadState GameState m) => DiffSpace -> m ()
movePlayerBy (DiffSpace spaces) = do
    let fn = coloured Green "movePlayerBy"
    playerIndex <- use playerTurn
    tell [fn <> ": Moving player " <> show playerIndex <> " by " <> show spaces <> " spaces."]
    players . element playerIndex . space %= (Space . (+ spaces) . getSpace)

performTeleportation :: (MonadWriter [String] m, MonadReader Game m, MonadState GameState m) => m ()
performTeleportation = do
    let fn = coloured Cyan "performTeleportation"
    teleports' <- view $ board . teleports
    playerIndex <- use playerTurn
    currentSpace <- use $ (players . Control.Lens.to (!! playerIndex) . space)
    tell [fn <> ": current space is " <> show currentSpace]
    case M.lookup (FromSpace . getSpace $ currentSpace) (getTeleports teleports')  of
        Just (ToSpace space') -> do
            tell [fn <> ": It was a teleport to " <> show space']
            players . element playerIndex . space .= Space space'
            currentSpace' <- use $ (players . Control.Lens.to (!! playerIndex) . space)
            tell [fn <> ": Cool. We are now at " <> show currentSpace']
        Nothing -> do
            tell [fn <> ": It was not a teleport."]

performRollover :: (MonadWriter [String] m, MonadReader Game m, MonadState GameState m) => m ()
performRollover = do
    let fn = coloured Magenta "performRollover"
    rolloverStrategy' <- view $ ruleset . rolloverStrategy
    playerIndex <- use playerTurn
    currentSpace <- use $ (players . Control.Lens.to (!! playerIndex) . space)
    tell [fn <> ": current space is " <> show currentSpace]
    finishingSpace <- view $ board . boardDimensions . stop
    startingSpace <- view $ board . boardDimensions . start
    let overflow = getSpace currentSpace - finishingSpace
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

nextPlayer :: (MonadWriter [String] m, MonadReader Game m, MonadState GameState m) => m ()
nextPlayer = do
    let fn = coloured Green "nextPlayer"
    numPlayers' <- view $ ruleset . numPlayers
    currentPlayer <- use playerTurn
    oldName' <- use $ (players . Control.Lens.to (!! currentPlayer) . name)
    tell [fn <> ": Current player is " <> show currentPlayer <> ", which is " <> oldName']
    playerTurn %= ((`mod` (getNumPlayers numPlayers')) . succ)
    newPlayer <- use playerTurn
    newName' <- use $ (players . Control.Lens.to (!! newPlayer) . name)
    tell [fn <> ": Next player is player " <> show newPlayer <> ", which is " <> newName']

roll :: (MonadWriter [String] m, MonadRandom m, MonadReader Game m, MonadState GameState m) => m ()
roll = do
    let fn = coloured Red "roll"
    moveProbabilities' <- view $ ruleset . moveProbabilities
    randomRoll <- getRandomByFrequencies $ getMoveProbabilities $ moveProbabilities'
    tell [fn <> ": Moving player by " <> show randomRoll]
    movePlayerBy randomRoll

turn :: (MonadWriter [String] m, MonadRandom m, MonadReader Game m, MonadState GameState m) => m ()
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

playUntilWinner :: (MonadWriter [String] m, MonadRandom m, MonadReader Game m, MonadState GameState m) => m Player
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
board1 :: Board
board1 = Board (BoardDimensions 1 100) (Teleports (M.fromList [
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

fairD6 :: MoveProbabilities
fairD6 = MoveProbabilities . M.fromList . zip (DiffSpace <$> [1..]) . replicate 6 $ (1 % 6)

normalRules :: Ruleset
normalRules = Ruleset Reverse fairD6 (NumPlayers 2)

initialGame :: Game
initialGame = Game {
    _board = board1,
    _ruleset = normalRules
}

initialState :: GameState
initialState = GameState {
    _players = [
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

main :: IO ()
main = do
    (winner, endingGameState, writeStream) <- runRWST playUntilWinner initialGame initialState
    mapM_ putStrLn writeStream
    putStrLn $ "The winner is: " <> winner ^. name <> "! Winning space: " <> show (winner ^. space) <> ". Took " <> show (endingGameState ^. turns) <> " turns."
    print endingGameState

-- @TODO average, space per colour
-- @TODO monadwriter with colours and for each function, add state for spacing