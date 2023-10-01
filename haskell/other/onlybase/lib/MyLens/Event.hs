{-# LANGUAGE Safe #-}

module MyLens.Event where

import MyLens

data Event = Event {
    _summary     :: String,
    _description :: String
} deriving stock (Show)

summary ∷ Lens' Event String
summary = lens _summary (\event summary' -> event { _summary = summary' })

description ∷ Lens' Event String
description = lens _description (\event description' -> event { _description = description' })
