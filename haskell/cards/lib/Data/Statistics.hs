module Data.Statistics where

import Control.Monad.Random
import Data.Bifunctor
import Data.Map             as M

-- combinator
countFreq ∷ (Traversable t, Num n, Ord a) ⇒ t a → M.Map a n
countFreq = Prelude.foldl' (\m v -> M.insertWith (+) v 1 m) M.empty

-- TODO compose for <$>

dist ∷ MonadRandom m ⇒ Int → m Int → m (M.Map Int Int)
dist n x = countFreq <$> replicateM n x

mean ∷ (Integral a) ⇒ [a] → Double
mean xs = fromIntegral (sum xs) / fromIntegral (length xs)

-- weighted average

meanDist ∷ M.Map Int Int → Double
meanDist = uncurry (/) . Prelude.foldl' (\(v1, t1) (v2, t2) -> (v1 + v2 * t2, t1 + t2)) (0, 0) . fmap (bimap fromIntegral fromIntegral) . M.toList
