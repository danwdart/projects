{-# LANGUAGE UnicodeSyntax #-}
module Lib.TH where

import           Language.Haskell.TH
import           Language.Haskell.TH.Quote
import           Language.Haskell.TH.Syntax

self ∷ Q Exp
self = do
    f <- runIO $ readFile "src/th.hs"
    stringE f

selfTyped ∷ Code Q String
selfTyped = liftCode . unsafeTExpCoerce $ do
    f <- runIO $ readFile "src/th.hs"
    stringE f

s ∷ QuasiQuoter
s = QuasiQuoter {
    quoteExp = stringE,
    quotePat = undefined,
    quoteType = undefined,
    quoteDec = undefined
}
