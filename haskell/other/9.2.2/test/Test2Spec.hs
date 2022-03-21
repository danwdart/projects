{-# LANGUAGE UnicodeSyntax #-}
module Test2Spec where

import           Control.Exception (evaluate)
import           Test.Hspec
import           Test.QuickCheck

prop ∷ [Int] → [Int] → Property
prop x y = collect (length x) $ length x > 3 ==> x ++ y === y ++ x

spec ∷ Spec
spec = describe "tests" $ do
    it "runs" $
        quickCheck prop
