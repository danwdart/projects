module Data.Code.JS.LambSpec where

import Control.Category.Execute.JSON
import Data.Code.JS.Lamb
import Data.Function.CollatzStep
import Data.Function.IsPalindrome
import           Test.Hspec hiding (runIO)
import           Test.Hspec.QuickCheck
import           Test.QuickCheck
import           Test.QuickCheck.Monadic

-- @TODO random functions

prop_IsPalindromeIsCorrectViaJSON :: String -> Property
prop_IsPalindromeIsCorrectViaJSON s = length s > 1 && all (`notElem` "$") s ==> withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaJSON (isPalindrome :: JSLamb String Bool) s
    pure $ answer === Just (isPalindrome s)

prop_CollatzStepIsCorrectViaJSON :: Int -> Property
prop_CollatzStepIsCorrectViaJSON i = withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaJSON (collatzStep :: JSLamb Int Int) i
    pure $ answer === Just (collatzStep i)

spec ∷ Spec
spec = describe "Code.JS.Lamb" $ do
    describe "executeViaJSON" $ do
        it "isPalindrome is correct" $
            property prop_IsPalindromeIsCorrectViaJSON
        it "collatzStep is correct" $
            property prop_CollatzStepIsCorrectViaJSON