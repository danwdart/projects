{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-unused-top-binds -Wno-unused-imports #-}

import Control.Concurrent
import Control.Concurrent.Async
import Control.Parallel
import Control.Parallel.Strategies
import GHC.Clock

slow :: String -> a -> IO a
slow _ x = do
    threadDelay 100000
    -- putStr $ label <> show x <> ", "
    pure x

timeR :: IO a -> IO (Double, a)
timeR ma = do
    before <- getMonotonicTime
    r <- ma
    after <- getMonotonicTime
    putStrLn $ "Time: " <> show (after - before)
    pure (after - before, r)


time :: IO a -> IO a
time ma = do
    before <- getMonotonicTime
    r <- ma
    after <- getMonotonicTime
    putStrLn $ "Time: " <> show (after - before)
    pure r

newtype Par f a = Par {
    getPar :: f a
} deriving (Show, Functor, Foldable, Traversable)
 
main :: IO ()
main = do
    putStrLn "Serial"
    numbers <- time $ mapM (slow "serial") [1..20 :: Int]
    print numbers

    putStrLn "Parallel wrapper (needs to actually be parallel)"
    numbersPar  <- time $ mapM (slow "par") (Par [1..20 :: Int])
    print numbersPar

    putStrLn "Concurrent"
    numbersConc <- time $ mapConcurrently (slow "conc") [1..20 :: Int]
    print numbersConc