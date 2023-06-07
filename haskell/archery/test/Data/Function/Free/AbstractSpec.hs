module Data.Function.Free.AbstractSpec where

import Control.Category.Interpret
import Data.Aeson
import Data.Function.CollatzStep
import Data.Function.IsPalindrome
import Data.Function.Free.Abstract
import Data.Primitive.Prims
import           Test.Hspec hiding (runIO)
import           Test.Hspec.QuickCheck
import           Test.QuickCheck
import           Test.QuickCheck.Monadic

myInterpret :: FreeFunc Prims a b -> a -> b
myInterpret = interpret

{-}
prop_IsPalindromeIsCorrectViaEncodeDecodeInterpret :: String -> Property
prop_IsPalindromeIsCorrectViaEncodeDecodeInterpret s = length s > 1 && all (`notElem` "$") s ==> withMaxSuccess 200 $ 
    (myInterpret <$> decode (encode (isPalindrome :: FreeFunc Prims String Bool)) <*> Just s) === Just (isPalindrome s)

prop_CollatzStepIsCorrectViaEncodeDecodeInterpret :: Int -> Property
prop_CollatzStepIsCorrectViaEncodeDecodeInterpret i = withMaxSuccess 200 $ 
    (myInterpret <$> decode (encode (collatzStep :: FreeFunc Prims Int Int)) <*> Just i) === Just (collatzStep i)
-}

-- @TODO random functions

spec ∷ Spec
spec = pure ()
    -- No FromJSON yet
    {-}
    describe "executeViaEncodeDecodeInterpret" $ do
        it "isPalindrome is correct" $
            property prop_IsPalindromeIsCorrectViaEncodeDecodeInterpret
        it "collatzStep is correct" $
            property prop_CollatzStepIsCorrectViaEncodeDecodeInterpret
    -}
    -- No Eq yet
    {-
    xdescribe "JSON isomorphism" $ do
        it "isPalindrome is isomorphic to its JSON representation" $
            decode (encode (isPalindrome :: FreeFunc Prims String Bool)) `shouldBe` Just (isPalindrome :: FreeFunc Prims String Bool)
        it "collatzStep is isomorphic to its JSON representation" $
            decode (encode (collatzStep :: FreeFunc Prims Int Int)) `shouldBe` Just (collatzStep :: FreeFunc Prims Int Int)
    -}