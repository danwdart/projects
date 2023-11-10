{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main (main) where

import Control.Monad.State
import World

-- IO
askName ∷ IO ()
askName = do
    putStrLn "[IO] What is your name?"
    name <- getLine
    putStrLn $ "[IO] Hello, " <> name

askNameW ∷ World → World
askNameW w1 = w4
    where w2 = putStrLnW "[W] What is your name?" w1
          (name, w3) = readLineW w2
          w4 = putStrLnW ("[W] Hello, " <> name) w3

branchW ∷ World → (World, World)
branchW w = (putStrLnW "Good" w, putStrLnW "Bad" w)

askNameT ∷ WorldT ()
askNameT = putStrLnT "[T] What is your name?" >>>
    readLineT >>>= \name ->
    putStrLnT $ "[T] Hello, " <> name

askNameM ∷ WorldM ()
askNameM = do
    putStrLnM "[M] What is your name?"
    name <- readLineM
    putStrLnM $ "[M] Hello, " <> name

askNameS ∷ WorldS ()
askNameS = do
    putStrLnS "[S] What is your name?"
    name <- readLineS
    putStrLnS $ "[S] Hello, " <> name

main ∷ IO ()
main = do
    askName
    print $ askNameW World
    print $ askNameT World
    print $ asT askNameM World
    print $ runState askNameS World
    pure ()
