-- Stolen from: https://www.youtube.com/watch?v=37uTCZqpqmk

{-# LANGUAGE DataKinds #-}
{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module TypeError where

import GHC.TypeLits

-- >>> id

instance TypeError (
    'Text "can't print out functions" ':$$:
    'Text "specifically, can't print something of type " ':<>: 'ShowType (a -> b)
    ) => Show (a -> b) where
    show _ = error "you'll never see this"
