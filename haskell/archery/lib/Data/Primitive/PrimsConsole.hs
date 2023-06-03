module Data.Primitive.PrimsConsole where

data PrimsConsole a b where
    OutputString :: PrimsConsole String ()
    InputString :: PrimsConsole () String

instance PrimitiveConsole (FreeFunc PrimsConsole) where
    outputString = Lift OutputString
    inputString = Lift InputString