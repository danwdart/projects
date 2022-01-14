{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Instances where

import Card
import System.Random

instance {-# OVERLAPPABLE #-} (Bounded a, Enum a) => Random a where
    random = randomR (minBound, maxBound)
    randomR (f, t) gen =
        let (rndInt, nxtGen) = randomR (fromEnum f, fromEnum t) gen
        in (toEnum rndInt, nxtGen)

instance (Bounded v, Bounded s) => Bounded (Card v s) where
    minBound = Card minBound minBound
    maxBound = Card maxBound maxBound