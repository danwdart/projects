{-# LANGUAGE Safe #-}

module Data.HKD.Generic (GSequence(..), sequenceG) where

import Data.Functor.Identity
import GHC.Generics

class GSequence f i o where
    gsequence :: i p → f (o p)

instance Applicative f ⇒ GSequence f (K1 a (f k'')) (K1 a k'') where
    gsequence (K1 k') = K1 <$> k'
    {-# INLINE gsequence #-}

instance (Applicative f, GSequence f i o, GSequence f i' o') ⇒ GSequence f (i :*: i') (o :*: o') where
    gsequence (l :*: r) = (:*:) <$> gsequence l <*> gsequence r
    {-# INLINE gsequence #-}

instance (Functor f, GSequence f i o, GSequence f i' o') ⇒ GSequence f (i :+: i') (o :+: o') where
    gsequence (L1 l) = L1 <$> gsequence l
    gsequence (R1 r) = R1 <$> gsequence r
    {-# INLINE gsequence #-}

instance (Functor f, GSequence f i o) ⇒ GSequence f (M1 _a _b i) (M1 _a' _b' o) where
    gsequence (M1 x) = M1 <$> gsequence x
    {-# INLINE gsequence #-}

instance GSequence f V1 V1 where
    gsequence = undefined
    {-# INLINE gsequence #-}

instance Applicative f ⇒ GSequence f U1 U1 where
    gsequence U1 = pure U1
    {-# INLINE gsequence #-}

sequenceG ∷ (Functor f, Generic (h f), Generic (h Identity), GSequence f (Rep (h f)) (Rep (h Identity))) ⇒
    h f → f (h Identity)
sequenceG = fmap to . gsequence . from
