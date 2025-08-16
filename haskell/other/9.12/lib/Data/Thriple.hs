
{-# LANGUAGE Safe                 #-}
{-# LANGUAGE UndecidableInstances #-}

module Data.Thriple (Thriple(..), Triple) where

import Data.Functor.Identity
import Data.HKD
import Data.Text             (Text)
import GHC.Generics

data Thriple f = Thriple {
    a :: HKD f Int,
    b :: HKD f Text,
    c :: HKD f Bool
} deriving (Generic)

deriving instance (
    Show (HKD f Text),
    Show (HKD f Int),
    Show (HKD f Bool)
    ) ⇒ Show (Thriple f)

type Triple = Thriple Identity
