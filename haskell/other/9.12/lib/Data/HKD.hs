{-# LANGUAGE Safe         #-}
{-# LANGUAGE TypeFamilies #-}

module Data.HKD (HKD) where

-- import Data.Functor.Const
import Data.Functor.Identity

type family HKD f a where
  -- this slightly screws with doing mapping as well.. we'll have to see...
  HKD Identity  a = a
  -- actually this screws with the generic stuff, we'll have to make extra cases which I cba to do now
  -- maybe we need to define the generic instance *in terms* of this.
  -- This seems to just cause issues though.
  -- HKD (Const b) _ = b
  HKD f         a = f a
