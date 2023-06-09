module Data.Primitive.PrimsSpec where

import Control.Category.Interpret
import Data.Primitive.Prims
import Test.Hspec                 hiding (runIO)
import Test.Hspec.QuickCheck
import Test.QuickCheck
import Test.QuickCheck.Monadic

-- @TODO random functions
-- @TODO proper name of this equality function - isomorphic?

{-}
prop_ReverseStringIsCorrectViaEncodeDecodeInterpret :: String -> Property
prop_ReverseStringIsCorrectViaEncodeDecodeInterpret s = length s > 1 && all (`notElem` "$") s ==> withMaxSuccess 200 $
    interpret (decode (encode reverseString)) s === reverseString s

prop_EqualIsCorrectViaEncodeDecodeInterpret :: (Int, Int) -> Property
prop_EqualIsCorrectViaEncodeDecodeInterpret is = withMaxSuccess 200 $
    interpret (decode (encode equal)) is === equal is
-}

spec ∷ Spec
spec = pure () {-describe "Data.Primitive.Prims" $ do
    describe "execution isomorphism" $ do
        prop "reverseString is correct" prop_ReverseStringIsCorrectViaEncodeDecodeInterpret
        prop "equal is correct" prop_EqualIsCorrectViaEncodeDecodeInterpret
    describe "JSON isomorphism" $ do
        it "ReverseString is isomorphic to its JSON representation" $
            decode (encode ReverseString) `shouldBe` ReverseString
        it "Equal is isomorphic to its JSON representation" $
            decode (encode Equal) `shouldBe` Equal -}
