module Data.Function.ReverseInputSpec where

import Test.Hspec

spec ∷ Spec
spec = pure ()

{-}
prop_RevInputProgramIsCorrectViaStdio :: String -> Property
prop_RevInputProgramIsCorrectViaStdio s = length s > 1 && all (`notElem` "$") s ==> withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaGHCi (revInputProgram :: HSFunc () ()) s
    pure $ answer === revInputProgram s
-}

{-}
prop_RevInputProgramIsCorrectViaStdio :: String -> Property
prop_RevInputProgramIsCorrectViaStdio s = length s > 1 && all (`notElem` "$") s ==> withMaxSuccess 200 . monadicIO $ do
    answer <- executeViaGHCi (revInputProgram :: HSFunc () ()) s
    pure $ answer === revInputProgram s
-}

{-}
    describe "executeViaStdio" $ do
        it "revInputProgram is correct" $
            property prop_RevInputProgramIsCorrectViaStdio

-}
