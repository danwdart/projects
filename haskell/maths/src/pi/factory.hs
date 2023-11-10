{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main (main) where

import Data.Ratio

-- import           Factory.Math.Implementations.Pi.BBP.Algorithm
-- import           Factory.Math.Implementations.Pi.BBP.Bellard
import Factory.Math.Implementations.Pi.BBP.Series
-- import           Factory.Math.Pi

main ∷ IO ()
main = pure ()

dig ∷ Series → [Ratio Integer]
dig (MkSeries numerators' getDenominators' _ base') = zipWith (*) (iterate (/ fromIntegral base') 1) $ fmap (sum . zipWith (%) numerators' . getDenominators') [0 ..]
