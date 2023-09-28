{-# OPTIONS_GHC -Wno-unused-imports -Wno-unused-top-binds #-}

import Data.Function
-- import           Data.List
import Data.Numbers.Primes

countfact ∷ [(Integer, Int)]
countfact = [(n, length $ primeFactors n) | n <- [1..1000]]

-- nubBy (on (==) snd) countfact

main ∷ IO ()
main = print countfact
