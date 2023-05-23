{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-safe -Wwarn #-}

module Data.DependentLengthSpec where

import           Control.Exception (evaluate)
import           Data.DependentLength
import           Data.Typeable
import           Test.Hspec
import           Test.QuickCheck

-- instance Arbitrary (Vec t a) where
--     arbitrary = fromList . arbitrary

{-# ANN module "HLint: ignore Functor law" #-}
functor :: (Eq a, Enum a, Eq (Vec t a), Show a) => Vec t a → Property
functor xs = fmap succ (fmap pred xs) === xs

spec :: Spec
spec = describe "DependentLength" $ do
    describe "on Int" $ do
        it "shows" $ do
            show ((0 :: Int) :> 1 :> 2 :> Nil) `shouldBe` "0 :> (1 :> (2 :> Nil))"
        it "has the correct type" $ do
            show (typeOf ((0 :: Int) :> 1 :> 2 :> Nil)) `shouldBe` "Vec 3 Int"
    describe "on Char" $ do
        it "shows" $ do
            show ('a' :> 'b' :> 'c' :> Nil) `shouldBe` "'a' :> ('b' :> ('c' :> Nil))"
        it "has the correct type" $ do
            show (typeOf ('a' :> 'b' :> 'c' :> Nil)) `shouldBe` "Vec 3 Char"
    -- describe "Functor instance" $ do
    --     it "functorises" $ do
    --         property functor
