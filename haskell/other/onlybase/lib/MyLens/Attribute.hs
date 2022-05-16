module MyLens.Attribute where

import MyLens
import MyLens.Date
import MyLens.Event

data Attributes = Attributes {
    _dob    :: Date,
    _events :: [(Date, Event)]
} deriving (Show)

dob ∷ Lens' Attributes Date
dob = lens _dob (\attributes' dob' -> attributes' { _dob = dob' })

events ∷ Lens' Attributes [(Date, Event)]
events = lens _events (\attributes' events' -> attributes' { _events = events' })
