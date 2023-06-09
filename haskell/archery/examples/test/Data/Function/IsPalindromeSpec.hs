module Data.Function.IsPalindromeSpec where

import Control.Category.Execute.Haskell
import Control.Category.Execute.JSON
import Data.Aeson
import Data.Code.Haskell.Func
import Data.Code.Haskell.Lamb
import Data.Code.JS.Lamb
import Data.Code.PHP.Lamb
import Data.Function.CollatzStep
import Data.Function.Greet
import Data.Function.IsPalindrome
import Data.Function.ReverseInput
import Data.Function.Free.Abstract
import Data.Primitive.Prims
import           Test.Hspec hiding (runIO)
import           Test.Hspec.QuickCheck
import           Test.QuickCheck
import           Test.QuickCheck.Monadic

prop_HSFuncIsCorrect :: String -> Property
prop_HSFuncIsCorrect s = length s > 1 && all (`notElem` "$") s ==> withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaGHCi (isPalindrome :: HSFunc String Bool) s
    pure $ answer === Right (isPalindrome s)


prop_HSLambIsCorrect :: String -> Property
prop_HSLambIsCorrect s = length s > 1 && all (`notElem` "$") s ==> withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaGHCi (isPalindrome :: HSLamb String Bool) s
    pure $ answer === Right (isPalindrome s)

prop_JSLambIsCorrect :: String -> Property
prop_JSLambIsCorrect s = length s > 1 && all (`notElem` "$") s ==> withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaJSON (isPalindrome :: JSLamb String Bool) s
    pure $ answer === Right (isPalindrome s)


prop_PHPLambIsCorrect :: String -> Property
prop_PHPLambIsCorrect s = length s > 1 && all (`notElem` "$") s ==> withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaJSON (isPalindrome :: PHPLamb String Bool) s
    pure $ answer === Right (isPalindrome s)

{-}

myInterpret = _

prop_ViaJSONIsCorrect :: String -> Property
prop_ViaJSONIsCorrect s = length s > 1 && all (`notElem` "$") s ==> withMaxSuccess 200 $ 
    (myInterpret <$> decode (encode (isPalindrome :: FreeFunc Prims String Bool)) <*> Just s) === Just (isPalindrome s)
-}

spec ∷ Spec
spec = describe "isPalindrome" $ do
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
    {-}
    describe "JSON" $ do
        it "is correct" $
            decode (encode (isPalindrome :: FreeFunc Prims String Bool)) `shouldBe` Just (isPalindrome :: FreeFunc Prims String Bool)
    -}