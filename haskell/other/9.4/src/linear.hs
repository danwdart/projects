{-# LANGUAGE LinearTypes       #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE Trustworthy       #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Main (main) where

import Control.Functor.Linear
import Prelude.Linear
import System.IO.Resource.Linear

main ∷ IO ()
main = run (pure (Ur ()))
