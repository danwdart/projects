module Data.Function.CollatzStepSpec where

import Control.Category.Execute.Haskell
import Control.Category.Execute.JSON
import Data.Aeson
import Data.Code.Haskell.Func
import Data.Code.Haskell.Lamb
import Data.Code.JS.Lamb
import Data.Code.PHP.Lamb
import Data.Function.CollatzStep
import Data.Function.Free.Abstract
import Data.Function.Greet
import Data.Function.IsPalindrome
import Data.Function.ReverseInput
import Data.Primitive.Prims
import Test.Hspec                       hiding (runIO)
import Test.Hspec.QuickCheck
import Test.QuickCheck
import Test.QuickCheck.Monadic

-- @TODO random functions

prop_HSFuncIsCorrect ∷ Int → Property
prop_HSFuncIsCorrect i = i >= 0 ==> withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaGHCi (collatzStep :: HSFunc Int Int) i
    pure $ answer === Right (collatzStep i)

prop_HSLambIsCorrect ∷ Int → Property
prop_HSLambIsCorrect i = i >= 0 ==> withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaGHCi (collatzStep :: HSLamb Int Int) i
    pure $ answer === Right (collatzStep i)

prop_JSLambIsCorrect ∷ Int → Property
prop_JSLambIsCorrect i = withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaJSON (collatzStep :: JSLamb Int Int) i
    pure $ answer === Right (collatzStep i)

prop_PHPLambIsCorrect ∷ Int → Property
prop_PHPLambIsCorrect i = withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaJSON (collatzStep :: PHPLamb Int Int) i
    pure $ answer === Right (collatzStep i)

{-}
myInterpret :: a
myInterpret = _

prop_ViaJSONIsCorrect :: Int -> Property
prop_ViaJSONIsCorrect i = withMaxSuccess 200 $
    (myInterpret <$> decode (encode (collatzStep :: FreeFunc Prims Int Int)) <*> Just i) === Just (collatzStep i)
-}


spec ∷ Spec
spec = describe "collatzStep" $ do
    describe "HSFunc" $ do
        it "is correct" $
            property prop_HSFuncIsCorrect
    describe "HSLamb" $ do
        it "is correct" $
            property prop_HSLambIsCorrect
    describe "JSLamb" $ do
        it "is correct" $
            property prop_JSLambIsCorrect
    describe "PHPLamb" $ do
        it "is correct" $
            property prop_PHPLambIsCorrect
    {-
    describe "JSON" $ do
        it "is correct" $
            -- decode (encode (collatzStep :: FreeFunc Prims Int Int)) `shouldBe` Just (collatzStep :: FreeFunc Prims Int Int)
    -}
