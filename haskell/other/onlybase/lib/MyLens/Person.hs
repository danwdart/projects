module MyLens.Person where

import MyLens
import MyLens.Attribute
import MyLens.Name

data Person = Person {
    _name       :: Name,
    _attributes :: Attributes
} deriving stock (Show)

name ∷ Lens' Person Name
name = lens _name (\person name' -> person { _name = name' })

attributes ∷ Lens' Person Attributes
attributes = lens _attributes (\person attributes' -> person { _attributes = attributes' })
