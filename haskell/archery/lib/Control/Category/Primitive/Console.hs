{-# LANGUAGE Safe #-}

module Control.Category.Primitive.Console where

import Control.Arrow (Kleisli (..))

class PrimitiveConsole cat where
    outputString :: cat String ()
    inputString :: cat () String
    --konst :: b -> cat a b

instance PrimitiveConsole (Kleisli IO) where
    outputString = Kleisli putStrLn
    inputString = Kleisli (const getLine)
