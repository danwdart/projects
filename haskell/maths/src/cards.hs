{-# LANGUAGE FlexibleInstances, UndecidableInstances #-}

import System.Random

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
main = return ()

data Value = Ace | Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten | Jack | Queen | King
    deriving (Bounded, Enum, Eq, Ord, Show)

data Suit = Hearts | Diamonds | Spades | Clubs
    deriving (Bounded, Enum, Eq, Ord, Show)

data Card = Card Value Suit | Joker deriving Eq

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

pack52 :: [Card]
pack52 = enumFromTo (Card Ace Hearts) (Card King Clubs)

pack :: [Card]
pack = pack52 <> [Joker]

again :: Semigroup c => Int -> c -> c
again = foldl1 (<>) ... replicate

cards :: [Card]
cards = again 4 pack52

pickCard :: State StdGen Card
pickCard = state random