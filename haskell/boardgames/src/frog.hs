{-# OPTIONS_GHC -Wno-unused-top-binds #-}

-- Expected number of jumps
-- Simulation
-- Formula

import           Control.Monad
import           Control.Monad.Random
import           Data.Foldable        as Foldable
import           Data.Map             (Map)
import qualified Data.Map             as M
-- import Data.Ratio
-- import Debug.Trace
-- import           System.Random

main ∷ IO ()
main = do
    putStrLn "Running the simulation. This may take a few seconds..."
    simResults <- replicateM 1000000 (randomJump 1 10)
    print . avg $ simResults
    print . freqList $ simResults

-- sim
randomJump ∷ Int → Int → IO Int
randomJump js total = do
    a <- randomRIO (1, total) :: IO Int
    if a < total
    then randomJump (js + 1) (total - a)
    else pure js

freqList ∷ [Int] → Map Int Int
freqList = Foldable.foldr' (\cur -> M.insertWith (const succ) cur 1) M.empty

avg ∷ [Int] → Double
avg xs = fromIntegral (sum xs) / fromIntegral (length xs)

-- calc
harmonic ∷ Integer → Rational
harmonic x = sum $ recip . fromIntegral <$> [1..x]

-- Answer should be:

-- PJ1: 1 % 10
-- PJ2: 1 % 10 * H(9)
-- PJ3: 1 % 10 *
-- PJ4:
-- PJ5:
-- PJ6:
-- PJ7:
-- PJ8:
-- PJ9:
-- PJ10: H(10)
