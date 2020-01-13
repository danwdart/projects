{-# LANGUAGE TupleSections #-}

-- https://en.wikipedia.org/wiki/One-handed_solitaire
import Control.Monad.Random.Class
import Data.Function
import Data.Functor
import System.Random.Shuffle

main :: IO ()
main = return ()

type Value = Int
type Suit = Int
type Card = (Value, Suit)
type Deck = [Card]
type Current = Deck
type InPlay = Deck
type Discard = Deck
type Game = (Current, InPlay, Discard)

fullPack :: Deck
fullPack = flip (,) <$> [1..4] <*> [1..13]

initialGameState :: MonadRandom m => m Game
initialGameState = ([], , []) <$> shuffleM fullPack


sameSuit :: Card -> Card -> Bool
sameSuit = on (==) snd

sameValue :: Card -> Card -> Bool
sameValue = on (==) fst


takeOne :: Game -> Game
takeOne = undefined

discardFour :: Game -> Game
discardFour = undefined

discardTwo :: Game -> Game
discardTwo = undefined