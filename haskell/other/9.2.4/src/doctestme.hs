{-# OPTIONS_GHC -Wno-unsafe #-}
{-# LANGUAGE Unsafe, TemplateHaskell #-}

module Main where

import Language.Haskell.TH
import Test.DocTest

-- | a!
-- >>> a
-- 1
--
a :: Int
a = 1

-- | This file.
-- >>> thisFile
-- "src/doctestme.hs"
thisFile :: String
thisFile = $(LitE . StringL . loc_filename <$> location)

main :: IO ()
main = doctest [thisFile]