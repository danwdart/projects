{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-unused-matches -Wno-incomplete-patterns -Wno-unused-imports #-}

-- Prime Number Snap
-- Rules: Draw cards until sequential cards add up to prime numbers, then discard these, and draw more until you run out of cards.

import           Card
import           Control.Monad.Random.Class
import           Data.Function
import           Data.Numbers.Primes
import           Deck
import           Suit.Unbounded
import           System.Random.Shuffle
import           Text.Printf
import           Value.Unbounded

main ∷ IO ()
main = do
    game <- playUntilEnd <$> initialGameState
    putStrLn . summariseGame $ game

type Current = DeckUnbounded
type InPlay = DeckUnbounded
type Discard = DeckUnbounded
type Game = (Current, InPlay, Discard) -- todo data / iter
data GameState = InProgress | Won | Lost deriving (Eq, Show)
data GameMove = TakeOne | DiscardTwo | DiscardFour | End deriving (Eq, Show)

summariseGame ∷ Game → String
summariseGame game@(curr, inp, disc) = "Game: " <>
    show (gameState game) <>
    ", with " <>
    show (length curr) <>
    " cards left, " <>
    show (length inp) <>
    " cards in play (available) and " <>
    show (length disc) <>
    " cards discarded."

fullPack ∷ DeckUnbounded
fullPack = Deck $ Card <$> fmap Value [1..13] <*> fmap Suit [1..4]

initialGameState ∷ MonadRandom m ⇒ m Game
initialGameState = (Deck [], , Deck []) . Deck <$> shuffleM (getDeck fullPack)

sameSuit ∷ CardUnbounded → CardUnbounded → Bool
sameSuit = on (==) suit

sameValue ∷ CardUnbounded → CardUnbounded → Bool
sameValue = on (==) value

roundStartReady ∷ Game → Bool
roundStartReady (Deck c, _, _) = length c >= 4

gameState ∷ Game → GameState
gameState (Deck c, Deck ip, _)
    | not (null ip) = InProgress
    | not (null c) = Lost
    | otherwise = Won

nextGameMove ∷ Game → GameMove
nextGameMove (Deck [], Deck [], _) = End
nextGameMove (_, Deck [], _) = End
nextGameMove (Deck (Card (Value v1) _:Card (Value v2) _:_), _, _)
    | isPrime (v1 + v2) = DiscardTwo
    | otherwise = TakeOne
nextGameMove _ = TakeOne

takeOne ∷ Game → Game
takeOne (Deck cs, Deck (ip:ips), ds) = (Deck (ip:cs), Deck ips, ds)

discardTwo ∷ Game → Game
discardTwo (Deck (c1:c2:cs), ips, Deck ds) = (Deck cs, ips, Deck (c1:c2:ds))

performMove ∷ Game → Game
performMove g = case nextGameMove g of
    End        -> g
    TakeOne    -> takeOne g
    DiscardTwo -> discardTwo g

playUntilEnd ∷ Game → Game
playUntilEnd g = if gameState g == InProgress then playUntilEnd $ performMove g else g

tryGame ∷ Game → GameState
tryGame = gameState . playUntilEnd
