{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Shell where

import Data.Foldable
import System.Directory

-- >>> ls
ls ∷ IO ()
ls = getCurrentDirectory >>= listDirectory >>= traverse_ putStrLn

-- >>> cat /etc/passwd
cat ∷ String → IO ()
cat s = readFile s >>= putStrLn
