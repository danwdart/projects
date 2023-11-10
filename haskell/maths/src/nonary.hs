{-# LANGUAGE DataKinds #-}

module Main (main) where

import Data.Kind
import GHC.TypeNats

-- data Nonary = Zero | One | Two | Three | Four | Five | Six | Seven | Eight

type InBase :: Nat → Type → Type
data InBase n a = InBase a

instance Num (InBase n a) where
    InBase x + InBase y = mod (natVal _) $ x + y
    InBase x * InBase y = mod (natVal _) $ x + y
    abs (InBase x) = _
    signum (InBase x) = _
    fromInteger x = InBase (mod _ x)
    negate x = InBase _

main ∷ IO ()
main = pure ()
