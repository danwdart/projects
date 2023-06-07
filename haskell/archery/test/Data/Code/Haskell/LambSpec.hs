module Data.Code.Haskell.LambSpec where

import Control.Category.Execute.Haskell
import Data.Code.Haskell.Lamb
import Data.Function.CollatzStep
import Data.Function.IsPalindrome
import           Test.Hspec hiding (runIO)
import           Test.Hspec.QuickCheck
import           Test.QuickCheck
import           Test.QuickCheck.Monadic

-- @TODO random functions

prop_IsPalindromeIsCorrectViaGHCi :: String -> Property
prop_IsPalindromeIsCorrectViaGHCi s = length s > 1 && all (`notElem` "$") s ==> withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaGHCi (isPalindrome :: HSLamb String Bool) s
    pure $ answer === isPalindrome s

prop_CollatzStepIsCorrectViaGHCi :: Int -> Property
prop_CollatzStepIsCorrectViaGHCi i = i >= 0 ==> withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaGHCi (collatzStep :: HSLamb Int Int) i
    pure $ answer === collatzStep i

spec ∷ Spec
spec = describe "Code.Haskell.Lamb" $ do
    describe "executeViaGHCi" $ do
        it "isPalindrome is correct" $
            property prop_IsPalindromeIsCorrectViaGHCi
        it "collatzStep is correct" $
            property prop_CollatzStepIsCorrectViaGHCi