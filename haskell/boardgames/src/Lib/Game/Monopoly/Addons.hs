{-# LANGUAGE UnicodeSyntax #-}
module Lib.Game.Monopoly.Addons where

data Addons = NoAddons | Houses Int | Hotel deriving (Eq)

instance Show Addons where
    show NoAddons = "(none)"
    show (Houses h) = show h <> " houses"
    show Hotel = "Hotel"
