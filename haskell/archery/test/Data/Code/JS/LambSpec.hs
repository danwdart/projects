module Data.Code.JS.LambSpec where

import Control.Category.Execute.JSON
import Data.Code.JS.Lamb
import Data.Function.CollatzStep
import Data.Function.Greet
import Data.Function.IsPalindrome
import           Test.Hspec hiding (runIO)
import           Test.Hspec.QuickCheck
import           Test.QuickCheck
import           Test.QuickCheck.Monadic

-- @TODO random functions

prop_IsPalindromeIsCorrectViaJSON :: String -> Property
prop_IsPalindromeIsCorrectViaJSON s = length s > 1 && all (`notElem` "$") s ==> withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaJSON (isPalindrome :: JSLamb String Bool) s
    pure $ answer === Right (isPalindrome s)

prop_CollatzStepIsCorrectViaJSON :: Int -> Property
prop_CollatzStepIsCorrectViaJSON i = withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaJSON (collatzStep :: JSLamb Int Int) i
    pure $ answer === Right (collatzStep i)

spec ∷ Spec
spec = describe "executeViaJSON" $ do
    it "isPalindrome is correct" $
        property prop_IsPalindromeIsCorrectViaJSON
    it "collatzStep is correct" $
        property prop_CollatzStepIsCorrectViaJSON
    describe "greet" $ do
        it "greetData is correct" $
            executeViaJSON (greetData :: JSLamb Person String) (Person "Dan" 32) `shouldReturn` Right (greetData (Person "Dan" 32))
        it "greetTuple is correct" $
            executeViaJSON (greetTuple :: JSLamb (String, Int) String) ("Dan", 32) `shouldReturn` Right (greetTuple ("Dan", 32))