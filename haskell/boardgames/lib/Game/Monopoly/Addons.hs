module Game.Monopoly.Addons where

data Addons = NoAddons | Houses Int | Hotel deriving stock (Eq)

instance Show Addons where
    show NoAddons   = "(none)"
    show (Houses h) = show h <> " houses"
    show Hotel      = "Hotel"
