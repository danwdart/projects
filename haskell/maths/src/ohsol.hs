{-# LANGUAGE TupleSections #-}

-- https://en.wikipedia.org/wiki/One-handed_solitaire

import Control.Monad (replicateM)
import Control.Monad.HT (nest)
import Control.Monad.Random.Class
import Data.Bifunctor
import Data.Function
import Data.Functor
import qualified Data.Map as M
import Debug.Trace
import System.Random.Shuffle

main :: IO ()
main = return ()

newtype Value = Value Int deriving (Eq)

instance Show Value where
    show (Value 13) = "K"
    show (Value 12) = "Q"
    show (Value 11) = "J"
    show (Value 1) = "A"
    show (Value n) = show n

newtype Suit = Suit Int deriving (Eq)

instance Show Suit where
    show (Suit 1) = "♥"
    show (Suit 2) = "♦"
    show (Suit 3) = "♠"
    show (Suit 4) = "♣"
    show (Suit x) = show x

data Card = Card {
    value :: Value,
    suit :: Suit
} deriving (Eq)

instance Show Card where
    show (Card v s) = show v ++ show s

type Deck = [Card]
type Current = Deck
type InPlay = Deck
type Discard = Deck
type Game = (Current, InPlay, Discard)
data GameState = InProgress | Won | Lost deriving (Eq, Show)
data GameMove = TakeOne | DiscardTwo | DiscardFour | End deriving (Eq, Show)

fullPack :: Deck
fullPack = flip Card <$> map Suit [1..4] <*> map Value [1..13]

initialGameState :: MonadRandom m => m Game
initialGameState = ([], , []) <$> shuffleM fullPack

sameSuit :: Card -> Card -> Bool
sameSuit = on (==) suit

sameValue :: Card -> Card -> Bool
sameValue = on (==) value

roundStartReady :: Game -> Bool
roundStartReady (c, _, _) = length c >= 4

gameState :: Game -> GameState
gameState (c, ip, _)
    | not (null ip) = InProgress
    | not (null c) = Lost
    | otherwise = Won

nextGameMove :: Game -> GameMove
nextGameMove ([], [], _) = End
nextGameMove (_, [], _) = End
nextGameMove ([], _, _) = TakeOne
nextGameMove ([c1], _, _) = TakeOne
nextGameMove (c1:_:_:c4:_, _, _)
    | sameSuit c1 c4 = DiscardTwo
    | sameValue c1 c4 = DiscardFour
    | otherwise = TakeOne
nextGameMove (c1:c2:c3:_, _, _) = TakeOne
nextGameMove (c1:c2:_, _, _) = TakeOne

takeOne :: Game -> Game
takeOne (cs, ip:ips, ds) = (ip:cs, ips, ds)

discardFour :: Game -> Game
discardFour (c1:c2:c3:c4:cs, ips, ds) = (cs, ips, c1:c2:c3:c4:ds)

discardTwo :: Game -> Game
discardTwo (c1:c2:c3:c4:cs, ips, ds) = (c1:c4:cs, ips, c2:c3:ds)

performMove :: Game -> Game
performMove g = case nextGameMove g of
    End -> g
    TakeOne -> takeOne g
    DiscardTwo -> discardTwo g
    DiscardFour -> discardFour g

playUntilEnd :: Game -> Game
playUntilEnd g = if gameState g == InProgress then playUntilEnd $ performMove g else g

tryGame :: Game -> GameState
tryGame = gameState . playUntilEnd





-- combinator
countFreq :: (Traversable t, Num n, Ord a) => t a -> M.Map a n
countFreq = Prelude.foldl (\m v -> M.insertWith (+) v 1 m) M.empty

-- TODO compose for <$>

dist :: MonadRandom m => Int -> m Int -> m (M.Map Int Int)
dist n x = countFreq <$> replicateM n x

mean :: (Num a, Integral a) => [a] -> Double
mean xs = fromIntegral (sum xs) / fromIntegral (length xs)

-- weighted average

meanDist :: M.Map Int Int -> Double
meanDist = uncurry (/) . Prelude.foldl (\(v1, t1) (v2, t2) -> (v1 + v2 * t2, t1 + t2)) (0, 0) . map (bimap fromIntegral fromIntegral) . M.toList
