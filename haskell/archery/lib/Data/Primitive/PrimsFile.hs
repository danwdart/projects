{-# LANGUAGE Safe #-}

module Data.Primitive.PrimsFile where

data PrimsFile a b where
    WriteFile :: PrimsFile (String, String) ()
    ReadFile :: PrimsFile String String
