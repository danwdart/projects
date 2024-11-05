module Main (main) where

import Data.Kind
import Data.Proxy
import GHC.TypeNats

-- data Nonary = Zero | One | Two | Three | Four | Five | Six | Seven | Eight

type InBase :: Nat → Type → Type
newtype InBase n a = InBase a
    deriving stock (Show)

instance (KnownNat n, Integral a) ⇒ Num (InBase n a) where
    InBase a1 + InBase a2 = InBase (mod (a1 + a2) (fromIntegral (natVal (Proxy :: Proxy n))))
    InBase a1 * InBase a2 = InBase (mod (a1 * a2) (fromIntegral (natVal (Proxy :: Proxy n))))
    abs a = a
    signum _ = InBase 1
    fromInteger a = InBase (fromIntegral $ mod a (fromIntegral (natVal (Proxy :: Proxy n))))
    negate (InBase a) = InBase (fromIntegral (natVal (Proxy :: Proxy n)) - a)

-- >>> :t InBase 2 + InBase 29 :: InBase 9 Int

main ∷ IO ()
main = do
    print (2 + 8 :: InBase 3 Int)
    print (22 * 92 :: InBase 100 Int)
