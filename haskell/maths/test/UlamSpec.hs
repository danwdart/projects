{-# OPTIONS_GHC -Wno-type-defaults #-}

module UlamSpec where

import           Test.Hspec
-- import Test.QuickCheck
import           Ulam

spec ∷ Spec
spec = do
    describe "iter" . it "should iterate correctly" $ (
            iter 5 succ 0 `shouldBe` 5)
    describe "writeGrid" . it "should return correct few ulams" $ (
            writeGrid 2 `shouldBe` [
                    Item 0 (0, 0) (1, 0),
                    Item 1 (1, 0) (0, 1),
                    Item 2 (1, 1) (-1, 0)
                    -- Item 3 (0, 1) (-1, 0) -- breaks at 3
                    -- Item 4 (1, -1) (0, -1)
                ])
