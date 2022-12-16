{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -Wno-unused-imports -Wno-orphans #-}

module Game.BounceSpec where

import           Control.Monad.IO.Class
import           Game.Bounce
import           Test.Hspec
import           Test.Hspec.QuickCheck
import           Test.QuickCheck
import           Test.QuickCheck.Arbitrary
import           Test.QuickCheck.Monadic

instance Arbitrary Corner where
    arbitrary = arbitraryBoundedEnum

disabled_prop_coordToMaybeCorner ∷ Size → Coord → Property
disabled_prop_coordToMaybeCorner size coord = 1 < fst size && 1 < snd size ==>
    (cornerToCoord size <$> coordToMaybeCorner size coord) === Just coord

prop_cornerToCoord ∷ Size → Corner → Property
prop_cornerToCoord size corner = 1 < fst size && 1 < snd size ==>
    coordToMaybeCorner size (cornerToCoord size corner) === Just corner

pure []

runTests ∷ IO Bool
runTests = $quickCheckAll

spec ∷ Spec
spec = prop "all" . monadicIO . liftIO $ runTests
