{-# LANGUAGE TemplateHaskellQuotes #-}
{-# LANGUAGE Safe #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-safe #-}

module RuntimeTypes where

import Data.Proxy
import Language.Haskell.TH

gen :: Proxy a -> Proxy b -> DecsQ
gen _ _ = [d|
    data MyType = AString String | AnInt Int
    data MyType2 a b = ATuple a | AThingy b

    data Record = Record {
        field :: MyType,
        field2 :: MyType2 Int String
    }
    |]