{-# OPTIONS_GHC -Wno-x-partial #-}

import Data.Number.CReal
import Data.Text                 qualified as T
import Data.Text.Internal.Search

wellwherearethey ∷ [Int]
wellwherearethey =  [(\xs -> if null xs then (-1) else head xs) . indices (T.pack . show @Integer . round $ x) . T.pack . filter (/= '.') . showCReal 1000 $ x ** (1 / x) | x <- [1..100] ]

main ∷ IO ()
main = print wellwherearethey

