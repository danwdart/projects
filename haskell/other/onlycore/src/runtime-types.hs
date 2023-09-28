{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE Trustworthy     #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-safe #-}

module Main where

import Data.Proxy
import Language.Haskell.TH
import RuntimeTypes
import System.Environment

gen (Proxy :: Proxy String) (Proxy :: Proxy Int)

-- >>> :t Record
-- (Error while loading modules for evaluation)
-- [1 of 2] Compiling Main             ( /home/dwd/code/mine/multi/projects/haskell/other/onlycore/src/runtime-types.hs, interpreted )
-- <BLANKLINE>
-- /home/dwd/code/mine/multi/projects/haskell/other/onlycore/src/runtime-types.hs:8:1-19: error:
--     Could not find module ‘RuntimeTypes’
--     Use -v (or `:set -v` in ghci) to see a list of the files searched for.
-- Failed, no modules loaded.
--

main ∷ IO ()
main = do
    args <- getArgs
    decs <- runQ $ gen (Proxy :: Proxy String) (Proxy :: Proxy Int)
    print decs
    print args
