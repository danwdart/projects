{-# LANGUAGE OverloadedLists #-}
{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-name-shadowing -Wno-incomplete-patterns -Wno-unused-matches -Wno-type-defaults -Wno-unused-imports -Wno-x-partial #-}

module Main (main) where

import Control.Comonad
import Control.Comonad.Env
import Control.Comonad.Store
import Control.Comonad.Traced
import Data.Foldable
import Data.List.NonEmpty     (NonEmpty)
import Data.List.NonEmpty     qualified as LNE
import Data.Map               (Map)
import Data.Map               qualified as M
import Data.Set               (Set)
import Data.Set               qualified as S
import GHC.Stack

newtype MyComonad a = MyComonad a deriving stock (Functor, Show)

instance Comonad MyComonad where
    extract (MyComonad a) = a
    duplicate = MyComonad

newtype MyComonad2 a = MyComonad2 a deriving stock (Functor, Show)

instance Comonad MyComonad2 where
    extract (MyComonad2 a) = a
    extend = (MyComonad2 .)

mc ∷ MyComonad Int
mc = MyComonad 1

data W2 p a = W2 p a deriving stock (Show)

instance Functor (W2 p) where
    fmap f (W2 p a) = W2 p (f a)

instance Comonad (W2 p) where
    extract (W2 p a) = a
    extend f w@(W2 p _) = W2 p (f w)

-- Stolen from Chris Penner's Comonads by Example

data Stream a = a :> Stream a deriving stock (Functor, Foldable)

-- A guess
instance (Show a) ⇒ Show (Stream a) where
    show (a :> (b :> (c :> (d :> (e :> _))))) =
        show a <> " :> " <> show b <> " :> " <> show c <> " :> " <> show d <> " :> " <> show e <> " ..."

instance Comonad Stream where
    extract (a :> _) = a
    -- A guess
    duplicate s@(_ :> b) = s :> duplicate b

fromList ∷ [a] → Stream a
fromList xs = go (cycle xs)
    where
        go ∷ [a] → Stream a
        go (a:rest) = a :> go rest

countStream ∷ Stream Int
countStream = fromList [0..]

ix ∷ HasCallStack => Int → Stream a → a
ix n _ | n < 0 = error "whoops"
ix 0 (a :> _) = a
ix n (_ :> rest) = ix (n - 1) rest

dropS ∷ Int → Stream a → Stream a
dropS n = ix n . duplicate

ix2 ∷ Int → Stream a → a
ix2 n = extract . dropS n

takeS ∷ Int → Stream a → [a]
takeS n input = take n (toList input)

filterS ∷ (a → Bool) → Stream a → Stream a
filterS pred (a :> s) = if pred a then a :> fs else fs
    where fs = filterS pred s

rollingAvg ∷ Int → Stream Int → Stream Double
rollingAvg n s = (\x -> fromIntegral x / fromIntegral n) . sum <$> extend (takeS n) s

evens, odds ∷ Stream Int
evens = filterS even countStream
odds = filterS odd countStream

inventory ∷ Map Int String
inventory = M.fromList [
    (0, "A"),
    (1, "B"),
    (2, "C"),
    (3, "D")
    ]

warehouse ∷ Store Int (Maybe String)
warehouse = store (`M.lookup` inventory) 1

squared ∷ Store Int Int
squared = store (\x -> x ^ (2 :: Int)) 10

aboveZero ∷ Int → Maybe Int
aboveZero n | n > 0 = Just n
            | otherwise = Nothing

withN ∷ Store Int (String, Int)
withN = squared =>> experiment (\n -> (show n, n))

-- GoL
startingGrid ∷ Store (Sum Int, Sum Int) Bool
startingGrid = store checkAlive (0, 0)

checkAlive ∷ (Sum Int, Sum Int) → Bool
checkAlive coord = S.member coord livingCells

livingCells ∷ Set (Sum Int, Sum Int)
livingCells = S.fromList [(1, 0), (2, 1), (0, 2), (1, 2), (2, 2)]

neighbourLocations ∷ (Sum Int, Sum Int) → [(Sum Int, Sum Int)]
neighbourLocations location = mappend location <$> [
    (-1, 1), (-1, 0), (-1, -1)
    , (0, -1),          (0,  1)
    , (1, -1), (1,  0), (1,  1)
    ]

numLivingNeighbours ∷ Store (Sum Int, Sum Int) Bool → Int
numLivingNeighbours = getSum . foldMap toCount . experiment neighbourLocations
    where
        toCount ∷ Bool → Sum Int
        toCount False = Sum 0
        toCount True  = Sum 1

checkCellAlive ∷ Store (Sum Int, Sum Int) Bool → Bool
checkCellAlive grid = case (extract grid, numLivingNeighbours grid) of
    (True, 3) -> True
    (_, 3)    -> True
    _         -> False

step ∷ Store (Sum Int, Sum Int) Bool → Store (Sum Int, Sum Int) Bool
step = extend checkCellAlive

-- TODO steal code from https://youtu.be/dOw7FRLVgY4?t=2520

-- End stolen

main ∷ IO ()
main = do
    print . runEnv $ env "hi" "a"
    print . snd . runStore $ store head "hey"
    print $ (runTraced $ traced head) "hello"
    print . extract $ mc
    print . duplicate $ mc
    print (mc =>> (\(MyComonad a) -> a + 1))
    print . extract . extend (\(MyComonad a) -> a + 1) $ mc
    print $ countStream =>> ix 2
    print $ countStream =>> ix 2 =>> ix 2
    print $ countStream =>> ix 2 =>> takeS 3
    print . extract $ countStream =>> ix 2 =>> takeS 3
    print . (ix 2 =>= ix 2 =>= ix 2) $ countStream
    print . (ix 2 =>= takeS 3) $ countStream
    do
        print $ pos warehouse
        print $ peek 0 warehouse
        print $ peeks (+ 1) warehouse
        print . pos $ seek 3 warehouse
        print . extract $ seeks (+ 2) warehouse
        print $ experiment (\x -> ([x, x + 1, x + 2] :: [Int])) warehouse
    do
        print $ experiment (\x -> ([x, x + 1, x + 2] :: [Int])) squared
        print $ experiment aboveZero (seek 10 squared)
        print $ experiment aboveZero (seek (- 10) squared)
        print $ extract withN
        print $ peek 5 withN
    do
        print $ peek (Sum 0, Sum 0) startingGrid
        print . experiment neighbourLocations $ step startingGrid
        print (experiment neighbourLocations . step $ step startingGrid)
        print (experiment neighbourLocations . step . step $ step startingGrid)
    do
        print $ ask (env (42 :: Int) "Hello")
        print $ asks succ (env (42 :: Int) "Hello")
        -- TODO abuse do
    do
        print . trace [1, 2, 3] $ traced (sum :: [Int] → Int)
        print . (trace (["Hi"] :: [String]) =>= trace (["Bob"] :: [String])) $ traced concat
    -- TODO https://www.youtube.com/watch?v=jTVVtJGu3D0
    -- TODO NonEmpty
