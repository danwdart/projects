{-# OPTIONS_GHC -Wno-unsafe #-}
{-# LANGUAGE Unsafe #-}

module Shell where

import           System.Directory

-- >>> ls
ls ∷ IO ()
ls = getCurrentDirectory >>= listDirectory >>= mapM_ putStrLn

-- >>> cat /etc/passwd
cat ∷ String → IO ()
cat s = readFile s >>= putStrLn
