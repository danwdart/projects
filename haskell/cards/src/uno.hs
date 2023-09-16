{-# OPTIONS_GHC -Wno-unused-imports #-}

module Main where

import           ANSI
import           Data.List.Extra
import qualified Data.List.NonEmpty as LNE
import           Data.Maybe
-- import           Debug.Trace
import           Uno.Action.Bounded
import           Uno.Card
import           Uno.Colour.Bounded
import           Uno.Value.Bounded
import           Uno.Wild.Bounded
import           System.Random.Shuffle

type Hand = [CardBounded]
type Hands = [Hand]
type Deck = [CardBounded]
type Discard = [CardBounded]
type NumberOfPlayers = Int
type Player = Int

data PlayDirection = Descending | Ascending deriving stock (Show, Eq, Enum)

type GameState = (Hands, Deck, Discard, Player, PlayDirection)

summariseGame :: GameState -> String
summariseGame (hands, deck, discard, player, playDirection) = "Hands: (" <>
    intercalate ", " (fmap (show . length) hands) <>
    "), deck: " <>
    show (length deck) <>
    ", discard: " <>
    show (length discard) <>
    ", player = " <>
    show player <>
    ", play direction = " <>
    show playDirection

-- @TODO make into lens
flipPlayDirection :: PlayDirection -> PlayDirection
flipPlayDirection Descending = Ascending
flipPlayDirection Ascending = Descending

nextPlayer :: GameState -> Player
nextPlayer (_, _, _, player, Ascending) = succ player `mod` numberOfPlayers
nextPlayer (_, _, _, player, Descending) = pred player `mod` numberOfPlayers

numberOfPlayers :: Int
numberOfPlayers = 2

cardsPerPlayer :: Int
cardsPerPlayer = 7

initialPlayDirection :: PlayDirection
initialPlayDirection = Ascending

startGame :: Deck -> Discard -> (Deck, Discard)
startGame deck discard = do
    case deck of
        (tryMatch:deck') -> do
            case tryMatch of
                NumberCard {} -> (deck', tryMatch:discard)
                other -> startGame (tail deck) (other:discard)
        _ -> error "Impossible to start game. No cards left to start. What have you done?"

renderHand :: Int -> Hand -> String
renderHand playerNumber hand = "Player " <> show playerNumber <> ": " <> show (length hand) <> " (" <> renderANSI hand <> ")"

matchesWith :: CardBounded -> CardBounded -> Bool
matchesWith (WildCard {}) _ = True
matchesWith _ (WildCard {}) = True
matchesWith (NumberCard value1 colour1) (NumberCard value2 colour2) = value1 == value2 || colour1 == colour2
matchesWith (NumberCard _ colour1) (ActionCard _ colour2) = colour1 == colour2
matchesWith (ActionCard _ colour1) (NumberCard _ colour2) = colour1 == colour2
matchesWith (ActionCard _ colour1) (ActionCard _ colour2) = colour1 == colour2

-- @TODO lenses!!
setAt :: Int -> a -> [a] -> [a]
setAt idx x xs = let (before, afterIncludingElement) = splitAt idx xs
    in before <> [x] <> tail afterIncludingElement

removeAt :: Int -> [a] -> [a]
removeAt idx xs = let (before, afterIncludingElement) = splitAt idx xs
    in before <> tail afterIncludingElement

playCard :: Int -> GameState -> GameState
playCard index gameState@(hands, deck, discard, player, playDirection) = (
    setAt player (
        removeAt index (
            hands !! player
        )
    ) hands,
    tail deck,
    hands !! player !! index : discard,
    nextPlayer gameState,
    playDirection)

takeCard :: Player -> GameState -> GameState
takeCard whom (hands, card:deck, discard, player, playDirection) = (
    setAt whom (
        card:hands !! whom
    ) hands,
    deck,
    discard,
    player,
    playDirection)
takeCard _ (_, [], _, _, _) = error "Nothing to take"

winner :: Hands -> Maybe Player
winner = findIndex null

applyN :: Int -> (a -> a) -> a -> a
applyN 0 _ x = x
applyN n f x = applyN (pred n) f x

-- Strategy: random choice for findIndex and wildness
move :: GameState -> GameState
move state@(hands, _deck, discard, player, _playDirection) = case findIndex (matchesWith (head discard)) (hands !! player) of
    Just index ->
        let newState@(hands', deck', discard', player', playDirection') = playCard index state
        in case winner hands' of
            Nothing -> case hands !! player !! index of
                NumberCard _value _colour -> newState
                ActionCard DrawTwo _colour -> move $ takeCard (nextPlayer state) $ takeCard (nextPlayer state) newState
                ActionCard Reverse _colour -> (hands', deck', discard', player', flipPlayDirection playDirection')
                ActionCard Skip _colour -> (hands', deck', discard', nextPlayer newState, playDirection')
                -- @TODO randomness
                WildCard Wild -> newState
                WildCard WildShuffleHands -> newState
                WildCard WildDrawFour -> newState
                WildCard WildCustomisable -> newState -- TODO customisable rule
            Just winner' -> error $ "Winner: " <> show winner'
    Nothing -> takeCard player state

main ∷ IO ()
main = do
    putStrLn $ show (length allCards) <> " cards in total."
    shuffled <- LNE.fromList <$> shuffleM (LNE.toList allCards)
    putStrLn $ "Shuffled deck: " <> renderANSI shuffled

    let (p1Hand, rest) = LNE.splitAt cardsPerPlayer shuffled
    putStrLn $ renderHand 1 p1Hand

    let (p2Hand, rest') = splitAt cardsPerPlayer rest
    putStrLn $ renderHand 2 p2Hand

    let (rest'', discard) = startGame rest' []

    putStrLn $ "Rest length: " <> show (length rest'') <> ", discard length: " <> show (length discard)

    putStrLn $ "Discard pile starts like: " <> renderANSI discard

    let initialGameState :: GameState
        initialGameState = ([p1Hand, p2Hand], rest'', discard, 0, Ascending)

    putStrLn $ "Initial game state: " <> summariseGame initialGameState

    putStrLn $ "Player 1 move"

    let gameState = move initialGameState

    putStrLn $ "New game state: " <> summariseGame gameState

    putStrLn $ "Player 2 move"

    let gameState' = move gameState

    putStrLn $ "New game state: " <> summariseGame gameState'

    let after50Moves = applyN 50 move gameState'

    putStrLn $ "After 50 more moves: " <> summariseGame after50Moves

    -- let endingState = until (isJust . winner . (\(hands, _, _, _, _) -> hands)) move initialGameState

    -- putStrLn $ "Ending game state: " <> summariseGame endingState