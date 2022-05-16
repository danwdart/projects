module Disparate where

data Disparate = forall a. (Show a) => ShowableDisparate a |
    forall b. HiddenDisparate b

instance Show Disparate where
    show (ShowableDisparate a) = show a
    show (HiddenDisparate _)   = "(hidden)"

data NamedDisparate = NamedDisparate {
    name  :: String,
    idn   :: Int,
    thing :: Disparate
} deriving (Show)