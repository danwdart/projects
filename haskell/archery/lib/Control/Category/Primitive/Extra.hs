{-# LANGUAGE Safe #-}

module Control.Category.Primitive.Extra where

import Control.Arrow (Kleisli(..))

class PrimitiveExtra cat where
    intToString :: cat Int String
    concatString :: cat (String, String) String
    constString :: String -> cat a String

instance PrimitiveExtra (->) where
    intToString = show
    concatString = uncurry (<>)
    constString = const

instance Monad m => PrimitiveExtra (Kleisli m) where
    intToString = Kleisli $ pure . show
    concatString = Kleisli $ pure . uncurry (<>)
    constString = Kleisli . const . pure
    