{-# LANGUAGE TypeOperators #-}

import Prelude hiding (succ, (.))
import Data.Invertible

-- Not really invertible but whatever
sqr :: (Fractional a, Floating a) => a <-> a
sqr = (^2) <-> sqrt

gammaI :: Double <-> Double
gammaI = involve recip . succ . involve negate . sqr

gamma, unGamma :: Double -> Double
gamma = biTo gammaI
unGamma = biFrom gammaI

main :: IO ()
main = return ()