{-# LANGUAGE UnicodeSyntax #-}
module TestSpec where

import           Control.Exception (evaluate)
import           Test.Hspec
import           Test.QuickCheck

prop ∷ [Int] → [Int] → Property
prop x y = collect (length x) $ length x > 3 ==> x ++ y === y ++ x

prop2 x y = collect (length x) $ length x > 3 ==> x ++ y === y ++ x
    where types = (x :: [Int], y :: [Int])

spec ∷ Spec
spec = describe "tests" $ do
    it "runs" $
        quickCheck prop
    it "runs 10000 times" $
        quickCheck (withMaxSuccess 10000 prop)
    it "checks" $
        1 `shouldBe` 1
    -- it "calcs prop" . property $ (\x -> (x :: Int) == (x :: Int))
    it "throws" $
        evaluate (1 `div` 0) `shouldThrow` anyException
    xit "runs IO" $ do
        -- length <$> readFile "/etc/passwd" `shouldReturn` 3512
        readFile "/etc/shadow" `shouldThrow` anyException
        (`shouldThrow` anyException) $ do
            _ <- readFile "/etc/shadow"
            readFile "/etc/passwd"
