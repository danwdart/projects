{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-unused-matches -Wno-incomplete-patterns #-}

-- https://en.wikipedia.org/wiki/One-handed_solitaire

import           Card
import           Control.Monad.Random.Class
import           Data.Function
import           Deck
import           Suit.Unbounded
import           System.Random.Shuffle
import           Value.Unbounded

main ∷ IO ()
main = pure ()

type Current = DeckUnbounded
type InPlay = DeckUnbounded
type Discard = DeckUnbounded
type Game = (Current, InPlay, Discard)
data GameState = InProgress | Won | Lost deriving (Eq, Show)
data GameMove = TakeOne | DiscardTwo | DiscardFour | End deriving (Eq, Show)

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
nextGameMove (Deck [], _, _) = TakeOne
nextGameMove (Deck [c1], _, _) = TakeOne
nextGameMove (Deck (c1:_:_:c4:_), _, _)
    | sameSuit c1 c4 = DiscardTwo
    | sameValue c1 c4 = DiscardFour
    | otherwise = TakeOne
nextGameMove (Deck (c1:c2:c3:_), _, _) = TakeOne
nextGameMove (Deck (c1:c2:_), _, _) = TakeOne

takeOne ∷ Game → Game
takeOne (Deck cs, Deck (ip:ips), ds) = (Deck (ip:cs), Deck ips, ds)

discardFour ∷ Game → Game
discardFour (Deck (c1:c2:c3:c4:cs), ips, Deck ds) = (Deck cs, ips, Deck (c1:c2:c3:c4:ds))

discardTwo ∷ Game → Game
discardTwo (Deck (c1:c2:c3:c4:cs), ips, Deck ds) = (Deck (c1:c4:cs), ips, Deck (c2:c3:ds))

performMove ∷ Game → Game
performMove g = case nextGameMove g of
    End         -> g
    TakeOne     -> takeOne g
    DiscardTwo  -> discardTwo g
    DiscardFour -> discardFour g

playUntilEnd ∷ Game → Game
playUntilEnd g = if gameState g == InProgress then playUntilEnd $ performMove g else g

tryGame ∷ Game → GameState
tryGame = gameState . playUntilEnd