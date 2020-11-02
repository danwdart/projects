{-# LANGUAGE TypeOperators #-}
{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-type-defaults #-}

import           Data.Invertible
import           Prelude         hiding (succ, (.))

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
