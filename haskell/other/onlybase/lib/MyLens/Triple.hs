{-# LANGUAGE Safe #-}

module MyLens.Triple where

import MyLens

data Triple a b c = Triple {
    ta :: a,
    tb :: b,
    tc :: c
} deriving stock (Show)

lensTripleA ∷ Lens (Triple a b c) (Triple a' b c) a a'
lensTripleA = lens ta (\(Triple _ b c) a' -> Triple a' b c)

lensTripleB ∷ Lens (Triple a b c) (Triple a b' c) b b'
lensTripleB = lens tb (\(Triple a _ c) b' -> Triple a b' c)

lensTripleC ∷ Lens (Triple a b c) (Triple a b c') c c'
lensTripleC = lens tc (\(Triple a b _) c' -> Triple a b c')
