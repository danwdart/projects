{-# LANGUAGE Safe #-}

module Control.Category.Cartesian where

import Control.Arrow

class Cartesian cat where
    copy :: cat a (a, a)
    consume :: cat a ()
    fst' :: cat (a, b) a
    snd' :: cat (a, b) b

instance Cartesian (->) where
    copy a = (a, a)
    consume _ = ()
    fst' = fst
    snd' = snd

instance Monad m => Cartesian (Kleisli m) where
    copy = Kleisli $ pure . copy
    consume = Kleisli $ pure . consume
    fst' = Kleisli $ pure . fst'
    snd' = Kleisli $ pure . snd'
