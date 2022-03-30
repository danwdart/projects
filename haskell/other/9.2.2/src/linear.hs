{-# LANGUAGE LinearTypes       #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Main where

import Control.Functor.Linear
import Prelude.Linear
import System.IO.Resource

main :: IO ()
main = run (pure (Ur ()))