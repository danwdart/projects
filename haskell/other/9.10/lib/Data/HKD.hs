{-# LANGUAGE Safe         #-}
{-# LANGUAGE TypeFamilies #-}

module Data.HKD (HKD) where

import Data.Functor.Const
import Data.Functor.Identity

type family HKD f a where
  HKD Identity  a = a
  HKD (Const b) _ = b
  HKD f         a = f a
