{-# LANGUAGE DefaultSignatures #-}
{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE Safe              #-}
{-# LANGUAGE UnicodeSyntax     #-}

module Data.HKD.Generic (hsequence, hmap) where

import Data.Functor.Identity
-- import Data.Kind
import GHC.Generics

class GHSequence f i o where
    ghsequence :: i p → f (o p)

instance Functor f ⇒ GHSequence f (K1 a (f k'')) (K1 a k'') where
    ghsequence (K1 k') = K1 <$> k'
    {-# INLINE ghsequence #-}

instance (Applicative f, GHSequence f i o, GHSequence f i' o') ⇒ GHSequence f (i :*: i') (o :*: o') where
    ghsequence (l :*: r) = (:*:) <$> ghsequence l <*> ghsequence r
    {-# INLINE ghsequence #-}

instance (Functor f, GHSequence f i o, GHSequence f i' o') ⇒ GHSequence f (i :+: i') (o :+: o') where
    ghsequence (L1 l) = L1 <$> ghsequence l
    ghsequence (R1 r) = R1 <$> ghsequence r
    {-# INLINE ghsequence #-}

instance (Functor f, GHSequence f i o) ⇒ GHSequence f (M1 _a _b i) (M1 _a' _b' o) where
    ghsequence (M1 x) = M1 <$> ghsequence x
    {-# INLINE ghsequence #-}

instance GHSequence f V1 V1 where
    ghsequence x = case x of { }
    {-# INLINE ghsequence #-}

instance Applicative f ⇒ GHSequence f U1 U1 where
    ghsequence U1 = pure U1
    {-# INLINE ghsequence #-}

hsequence ∷ (Functor f, Generic (h f), Generic (h Identity), GHSequence f (Rep (h f)) (Rep (h Identity))) ⇒ h f → f (h Identity)
hsequence = fmap to . ghsequence . from

class GHFunctor f g i o where
    ghmap :: (forall a. f a → g a) → i p → o p

instance GHFunctor f g (K1 a (f k)) (K1 a (g k)) where
    ghmap f (K1 k') = K1 $ f k'
    {-# INLINE ghmap #-}

instance (GHFunctor f g i o, GHFunctor f g i' o') ⇒ GHFunctor f g (i :*: i') (o :*: o') where
    ghmap f (l :*: r) = (:*:) (ghmap f l) (ghmap f r)
    {-# INLINE ghmap #-}

instance (GHFunctor f g i o, GHFunctor f g i' o') ⇒ GHFunctor f g (i :+: i') (o :+: o') where
    ghmap f = \case
        L1 x -> L1 $ ghmap f x
        R1 x -> R1 $ ghmap f x
    {-# INLINE ghmap #-}

instance (GHFunctor f g i o) => GHFunctor f g (M1 _a _b i) (M1 _a _b o) where
    ghmap f (M1 x) = M1 (ghmap f x)
    {-# INLINE ghmap #-}

instance GHFunctor f g V1 V1 where
    ghmap _ = \case
    {-# INLINE ghmap #-}

instance GHFunctor f g U1 U1 where
    ghmap _ U1 = U1
    {-# INLINE ghmap #-}

hmap ∷ (Generic (h f), Generic (h g), GHFunctor f g (Rep (h f)) (Rep (h g))) ⇒ (forall a. f a → g a) → h f → h g
hmap f = to . ghmap f . from


-- class GHZip f g h i o where
--     ghzipWith :: (forall a. f a -> g a -> h a) -> i1 p -> i2 p -> o p
-- 
-- hzipWith :: (eneric (hkd f)) => (forall a. f a -> g a -> h a) -> hkd f -> hkd g -> hkd h
-- hzipWith f = to . ghzipWith f . from

{-}
hpure ∷ (Generic (h f), Generic (h Identity), GHPure f (Rep (h Identity)) (Rep (h f))) ⇒ (forall a. a → f a) → h Identity → h f
hpure f = to . ghpure f . from
-}

{-class HSequence f where
    hSequence :: h f → f (h Identity)
    default
-}


-- class GMap f g i o where
--     gmap :: (forall a. f a -> g a) -> i p -> o p

-- instance GMap ()

-- hmap ∷ (Generic (h f), Generic (h g), GMap f g (Rep (h f)) (Rep (h g))) => (f a -> g a) -> h f -> h g
-- hmap = to . gmap . from
-- class HMap f where

    -- default hmap :: (Generic (h f), Generic (h g), GMap f g (Rep (h f)) (Rep (h g))) => (forall a. f a -> g a) -> h f -> h g
    -- hmap = to . gmap . from
