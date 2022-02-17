{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE UnicodeSyntax #-}

module Deck where

newtype Deck a = Deck [a]
    deriving (Eq, Functor, Show)
