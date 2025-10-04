{-# LANGUAGE Safe #-}

module MyLens.Name where

import MyLens
import MyLens.Title

data Name = Name {
    _title        :: Title,
    _chosenName    :: String,
    _officialName :: String
} deriving stock (Show)

title ∷ Lens' Name Title
title = lens _title (\name' title' -> name' { _title = title' })

chosenName ∷ Lens' Name String
chosenName = lens _chosenName (\name' chosenName' -> name' { _chosenName = chosenName' })

officialName ∷ Lens' Name String
officialName = lens _officialName (\name' officialName' -> name' { _officialName = officialName' })
