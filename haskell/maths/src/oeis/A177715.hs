{-# OPTIONS_GHC -Wno-x-partial #-}

module Main (main) where

import Data.Number.CReal
import Data.Text                 qualified as T
import Data.Text.Internal.Search

wellwherearethey ∷ [Int]
wellwherearethey =  [(\xs -> if null xs then (-1) else head xs) . indices (T.show @Integer . round $ x) . T.pack . filter (/= '.') . showCReal 1000 $ sqrt x | x <- [1..100] ]

main ∷ IO ()
main = print wellwherearethey

