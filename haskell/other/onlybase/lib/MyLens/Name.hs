module MyLens.Name where

import MyLens
import MyLens.Title

data Name = Name {
    _title        :: Title,
    _givenName    :: String,
    _officialName :: String
} deriving (Show)

title ∷ Lens' Name Title
title = lens _title (\name' title' -> name' { _title = title' })

givenName ∷ Lens' Name String
givenName = lens _givenName (\name' givenName' -> name' { _givenName = givenName' })

officialName ∷ Lens' Name String
officialName = lens _officialName (\name' officialName' -> name' { _officialName = officialName' })
