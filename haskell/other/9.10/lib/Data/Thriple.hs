{-# LANGUAGE DeriveGeneric        #-}
{-# LANGUAGE Safe                 #-}
{-# LANGUAGE UndecidableInstances #-}

module Data.Thriple (Thriple(..), Triple) where

import Data.Functor.Identity
import Data.HKD
import GHC.Generics

data Thriple f = Thriple {
    a :: HKD f Int,
    b :: HKD f String,
    c :: HKD f Bool
} deriving (Generic)

deriving instance (
    Show (HKD f String),
    Show (HKD f Int),
    Show (HKD f Bool)
    ) ⇒ Show (Thriple f)

type Triple = Thriple Identity
