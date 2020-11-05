{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import           Data.Ratio

-- import           Factory.Math.Implementations.Pi.BBP.Algorithm
-- import           Factory.Math.Implementations.Pi.BBP.Bellard
import           Factory.Math.Implementations.Pi.BBP.Series
-- import           Factory.Math.Pi

main ∷ IO ()
main = return ()

dig ∷ Series → [Ratio Integer]
dig (MkSeries numerators' getDenominators' _ base') = zipWith (*) (iterate (/ fromIntegral base') 1) $ fmap (sum . zipWith (%) numerators' . getDenominators') [0 ..]
