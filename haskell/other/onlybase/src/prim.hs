{-# LANGUAGE MagicHash   #-}
{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Main (main) where

import GHC.Exts
-- import GHC.IO
-- import GHC.Prim
-- import GHC.Types

main ∷ IO ()
main = do
    print $ I# 2#
    print $ C# 'E'#
    print (2 :: Int, 2 :: Int)
