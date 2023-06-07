module Data.Code.Haskell.FuncSpec where

import Control.Category.Execute.Haskell
import Data.Code.Haskell.Func
import Data.Function.CollatzStep
import Data.Function.Greet
import Data.Function.IsPalindrome
import Data.Function.ReverseInput
import           Test.Hspec hiding (runIO)
import           Test.Hspec.QuickCheck
import           Test.QuickCheck
import           Test.QuickCheck.Monadic

-- @TODO random functions

prop_IsPalindromeIsCorrectViaGHCi :: String -> Property
prop_IsPalindromeIsCorrectViaGHCi s = length s > 1 && all (`notElem` "$") s ==> withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaGHCi (isPalindrome :: HSFunc String Bool) s
    pure $ answer === Right (isPalindrome s)

prop_CollatzStepIsCorrectViaGHCi :: Int -> Property
prop_CollatzStepIsCorrectViaGHCi i = i >= 0 ==> withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaGHCi (collatzStep :: HSFunc Int Int) i
    pure $ answer === Right (collatzStep i)

{-}
prop_RevInputProgramIsCorrectViaStdio :: String -> Property
prop_RevInputProgramIsCorrectViaStdio s = length s > 1 && all (`notElem` "$") s ==> withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaGHCi (revInputProgram :: HSFunc () ()) s
    pure $ answer === revInputProgram s
-}

spec ∷ Spec
spec = describe "executeViaGHCi" $ do
        it "isPalindrome is correct" $
            property prop_IsPalindromeIsCorrectViaGHCi
        it "collatzStep is correct" $
            property prop_CollatzStepIsCorrectViaGHCi
        describe "greet" $ do
            it "greetData is correct" $
                executeViaGHCi (greetData :: HSFunc Person String) (Person "Dan" 32) `shouldReturn` Right (greetData (Person "Dan" 32))
            it "greetTuple is correct" $
                executeViaGHCi (greetTuple :: HSFunc (String, Int) String) ("Dan", 32) `shouldReturn` Right (greetTuple ("Dan", 32))

    {-}
    describe "executeViaStdio" $ do
        it "revInputProgram is correct" $
            property prop_RevInputProgramIsCorrectViaStdio
    -}