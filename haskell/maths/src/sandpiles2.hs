{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE RequiredTypeArguments #-}
{-# LANGUAGE RoleAnnotations #-}

module Main (main) where

import Data.Functor.Compose
import Data.Kind
import Data.Proxy
import Data.Type.Equality
import Data.Type.Ord
import GHC.TypeLits
-- import GHC.TypeNats

main ∷ IO ()
main = pure ()

type Sandpile :: Nat -> Nat -> Nat -> Type
newtype Sandpile (width :: Nat) (height :: Nat) (maxEntry :: Nat) = Sandpile [[Nat]] -- TODO typed vector
    deriving (Eq)
    deriving (Foldable) via (Compose)
type role Sandpile phantom phantom nominal

-- traversable? foldable?

-- todo lens?
-- class Ix a where
--     type Index ix
--     type 
--     get :: ix -> 

indexInto :: (Nat, Nat) -> Sandpile width height maxEntry -> Nat
indexInto (x, y) (Sandpile xss) = xss !! (fromIntegral x) !! (fromIntegral y)

getAt :: Integral ix => ix -> [a] -> a
getAt ix xs = xs !! (fromIntegral ix)

setAt :: Integral ix => ix -> a -> [a] -> [a]
setAt ix new xs = take (fromIntegral ix) xs <> [new] <> drop ((fromIntegral ix) + 1) xs

modAt :: Integral ix => ix -> (a -> a) -> [a] -> [a]
modAt ix f xs = take (fromIntegral ix) xs <> [f (xs !! (fromIntegral ix))] <> drop ((fromIntegral ix) + 1) xs

setInto :: (Nat, Nat) -> Nat -> Sandpile width height maxEntry -> Sandpile width height maxEntry
setInto (x, y) new (Sandpile xss) = Sandpile $ modAt y (\xs -> setAt x new xs) xss

instance Show (Sandpile w h m) where
    show (Sandpile xss) = unlines . fmap unwords . fmap (fmap show) $ xss

-- Fields and such
-- instance Field

addSP :: Sandpile w h m -> Sandpile w h m -> Sandpile w h m
addSP (Sandpile xss) (Sandpile yss) = toppleAll $ Sandpile $ (\xs ys -> (+) <$> xs <*> ys) <$> xss <*> yss

mulScalar :: Nat -> Sandpile w h m -> Sandpile w h m
mulScalar n (Sandpile xss) = toppleAll $ Sandpile $ fmap (fmap (* 2)) xss

repeatUntilSame :: Eq a => (a -> a) -> a -> a
repeatUntilSame f x = if f x == x then x else repeatUntilSame f (f x)

topple :: Sandpile w h m -> Sandpile w h m
topple = undefined

toppleAll :: Sandpile w h m -> Sandpile w h m
toppleAll = repeatUntilSame topple

zero3x3 :: Sandpile 3 3 3
zero3x3 = Sandpile [[3,3,3],[3,3,3],[3,3,3]]