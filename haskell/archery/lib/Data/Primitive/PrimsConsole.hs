{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Data.Primitive.PrimsConsole where

import Control.Category.Primitive.Console
import Data.Function.Free.Abstract

data PrimsConsole a b where
    OutputString :: PrimsConsole String ()
    InputString :: PrimsConsole () String

instance PrimitiveConsole (FreeFunc PrimsConsole) where
    outputString = Lift OutputString
    inputString = Lift InputString