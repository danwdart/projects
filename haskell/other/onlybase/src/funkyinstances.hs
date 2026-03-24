module Main (main) where

import Control.Monad
-- import Control.Monad.Error.Class
import Data.Traversable

main :: IO ()
main = do
    -- Function monad lets you take out your initial fmap condition and/or make a fmap that accepts a partial application?
    -- Uses Applicative for (->) r
    print $ traverse (+) [1..10 :: Int] 2
    print $ for [1..10 :: Int] (+) 2
    -- Applicative for either when also lets you do things in non-IO
    -- print $ when False (throwError "Hi") :: Either String Int
    -- print $ when True (throwError "Hi") :: Either String Int
    -- and also useless things
    print (void (Left 2) :: Either Int ()) -- Left 2
    print (void (Right (2 :: Int)) :: Either Int ()) -- Right ()
