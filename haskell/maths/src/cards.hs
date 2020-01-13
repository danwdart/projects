-- https://en.wikipedia.org/wiki/Playing_cards_in_Unicode

{-# LANGUAGE FlexibleInstances, UndecidableInstances #-}

import Control.Monad
import qualified Control.Monad.HT as HT (nest, repeat)
import Control.Monad.IO.Class
import Control.Monad.Random.Class
import Control.Monad.Trans.State
import Data.Bifoldable
import Data.Function
import Data.Functor
import qualified Data.Map as M
import qualified Data.Set as S
import System.Random
import System.Random.Shuffle

-- https://wiki.haskell.org/Random_shuffle

instance {-# OVERLAPPABLE #-} (Bounded a, Enum a) => Random a where
    random = randomR (minBound, maxBound)
    randomR (f, t) gen =
        let (rndInt, nxtGen) = randomR (fromEnum f, fromEnum t) gen
        in (toEnum rndInt, nxtGen)

-- randomElem :: RandomGen g => [a] -> g -> (a, g)
-- randomElem elems g = elems !! randomR (0, length elems 

(...) :: (b -> c) -> (a1 -> a2 -> b) -> a1 -> a2 -> c
(...) = (.) . (.)

main :: IO ()
main = do
    putStrLn "Average matches in one round (even-ing out the two lines)"
    meanDist <$> avgDist 2000 >>= print
    putStrLn "Average non-matches after finishing rounds"
    meanDist <$> magicDist 2000 >>= print

class Pp a where
    pp :: a -> String

ppr :: Pp a => a -> IO ()
ppr = putStrLn . pp

data Value = Ace | Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten | Jack | Queen | King
    deriving (Bounded, Enum, Eq, Ord, Show)

instance Pp Value where
    pp Ace = "A"
    pp Two = "2"
    pp Three = "3"
    pp Four = "4"
    pp Five = "5"
    pp Six = "6"
    pp Seven = "7"
    pp Eight = "8"
    pp Nine = "9"
    pp Ten = "10"
    pp Jack = "J"
    pp Queen = "Q"
    pp King = "K"

data Suit = Hearts | Diamonds | Spades | Clubs
    deriving (Bounded, Enum, Eq, Ord, Show)

instance Pp Suit where
    pp Hearts = "♥"
    pp Diamonds = "♦"
    pp Spades = "♠"
    pp Clubs = "♣"

data Card = Card Value Suit | Joker deriving (Eq, Ord)

instance Pp Card where
    pp (Card value suit) = pp value ++ pp suit
    pp Joker = "🃏"

ov = Card

type Deck = [Card]

instance Enum Card where
    toEnum 52 = Joker
    toEnum n = Card (toEnum v) (toEnum s)
        where (s, v) = n `divMod` 13
    fromEnum Joker = 52
    fromEnum (Card value suit) = fromEnum value + (13 * fromEnum suit)

instance Bounded Card where
    minBound = Card Ace Hearts
    maxBound = Joker

instance Show Card where
    show (Card value suit) = show value ++ " of " ++ show suit
    show Joker = "Joker"

uniq :: Ord a => [a] -> [a]
uniq = S.toList . S.fromList

listToPairs :: [a] -> [(a, a)]
listToPairs x = zip x (tail x)

pairsToList :: (Ord a) => [(a, a)] -> [a]
pairsToList = uniq . concatMap biList

adj :: (Enum a) => a -> a -> Bool
adj a b = 1 == abs (fromEnum a - fromEnum b)

filterOutList :: (Eq a) => [a] -> [a] -> [a]
filterOutList bads = filter (not . flip elem bads) -- todo reduce

-- combinator
countFreq :: (Traversable t, Num n, Ord a) => t a -> M.Map a n
countFreq = Prelude.foldl (\m v -> M.insertWith (+) v 1 m) (M.fromList [])

-- TODO compose for <$>

dist :: MonadRandom m => Int -> m Int -> m (M.Map Int Int)
dist n x = countFreq <$> replicateM n x

mean :: (Num a, Integral a) => [a] -> Double
mean xs = fromIntegral (sum xs) / fromIntegral (length xs)

-- weighted average

meanDist :: M.Map Int Int -> Double
meanDist = uncurry (/) . Prelude.foldl (\(v1, t1) (v2, t2) -> (v1 + v2 * t2, t1 + t2)) (0, 0) . map (\(a, b) -> (fromIntegral a, fromIntegral b)) . M.toList

eqOrAdj :: Card -> Card -> Bool
eqOrAdj Joker Joker = True
eqOrAdj (Card value1 suit1) (Card value2 suit2) = value1 == value2 || (suit1 == suit2 && adj value1 value2)
eqOrAdj _ _ = False

-- filter out?

adjPairs :: Deck -> [(Card, Card)]
adjPairs x = filter (uncurry eqOrAdj) (listToPairs x)

pack52 :: Deck
pack52 = enumFromTo (Card Ace Hearts) (Card King Clubs)

pack :: Deck
pack = pack52 <> [Joker]

again :: Semigroup c => Int -> c -> c
again = foldl1 (<>) ... replicate

fourpacks :: Deck
fourpacks = again 4 pack52

pickRandomCards :: MonadRandom m => Int -> Deck -> m (Deck, Deck)
pickRandomCards n p = splitAt n <$> shuffleM p

pokerHand :: MonadRandom m => Deck -> m (Deck, Deck)
pokerHand = pickRandomCards 5

adjCards :: Deck -> Deck
adjCards c = pairsToList . filter (uncurry eqOrAdj) $ listToPairs c

extractAdj :: MonadRandom m => Deck -> m Deck
extractAdj p = do
    p' <- shuffleM p
    return $ filterOutList (adjCards p') p'

magicNumbers :: MonadRandom m => m Int
magicNumbers = length <$> HT.nest 30 extractAdj pack

magicDist :: MonadRandom m => Int -> m (M.Map Int Int)
magicDist n = dist n magicNumbers

-- replicateM 200 magicNumbers

avgNumbers :: MonadRandom m => m Int
avgNumbers = length . adjCards <$> shuffleM pack

avgDist :: MonadRandom m => Int -> m (M.Map Int Int)
avgDist n = dist n avgNumbers

-- todo generalise with ints for numbers and decks!

-- anything to do with log2 52? Let's generalise.