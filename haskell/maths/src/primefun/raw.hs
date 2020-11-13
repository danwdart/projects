{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-incomplete-patterns #-}

import           Control.Monad.Fix

notdiv :: Integral a => a -> a -> Bool
notdiv x y = y `mod` x /= 0

-- appears faster, is it tho
primes :: [Integer]
primes = sieve [2..] where sieve (x:xs) = x : sieve (filter (notdiv x) xs)

-- appears slower, is it tho
pf :: [Integer]
pf = fix (\sieve (x:xs) -> x : sieve (filter (notdiv x) xs)) [2..]

main :: IO ()
main = pure ()
