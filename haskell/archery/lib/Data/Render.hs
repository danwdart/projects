{-# LANGUAGE Safe #-}

module Data.Render where

class Render a where
    render :: a -> String