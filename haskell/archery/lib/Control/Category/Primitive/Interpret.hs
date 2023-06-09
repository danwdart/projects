{-# LANGUAGE Safe #-}

module Control.Category.Primitive.Interpret where

class InterpretPrim cat1 cat2 where
    interpretPrim :: cat1 a b → cat2 a b
