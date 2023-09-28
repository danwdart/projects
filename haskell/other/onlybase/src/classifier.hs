{-# OPTIONS_GHC -Wno-unused-imports #-}
-- statistics on classifications
module Main where

import Data.Functor.Const
-- import Data.Functor.Constant

{-
We can't duplicate like this!
data CountryMoralityWeighting =  CountryMoralityWeighting {
    capitalPunishment :: Int,
    genderEquality :: Int,
    sexualityEquality :: Int
}

data CountryMorality = CountryMorality {
    capitalPunishment :: Bool,
    genderEquality :: Bool,
    sexualityEquality :: Bool
}
-}

-- Let's split out the fields into a meta type and a data type.
-- Looks like we're going either map or HKD.

-- Just one type param is just the same as a functor but with multiple arguments. Like a map. But not one.
-- k :: t Type would be hkd.

-- If we have one default or multiple ways of transformation of data we can use hkd.
-- Otherwise we can use the extended functor pattern.
-- Strangely either way it would be D t1 -> D t2

-- Maybe instead of bimap there ought to be a generic map for single function / multi value, multi function / single value, multi function / multi value
-- not necessarily dot/cross

data Country t = Country {
    name     :: String,
    morality :: t
} deriving stock (Functor, Show)

data CountryMorality t = CountryMorality {
    capitalPunishment :: t,
    genderEquality    :: t,
    sexualityEquality :: t
}

moralityWeightings ∷ CountryMorality Int
moralityWeightings = CountryMorality {
    capitalPunishment = 100,
    genderEquality = 100,
    sexualityEquality = 100
}

moralityLabels ∷ CountryMorality String
moralityLabels = CountryMorality {
    capitalPunishment = "Capital punishment",
    genderEquality = "Gender equality",
    sexualityEquality = "Sexuality equality"
}

countryData ∷ [Country (CountryMorality Bool)]
countryData = [
    Country "Bobland" (CountryMorality True True True),
    Country "Jimland" (CountryMorality False False False)
    ]

summariseCountry ∷ Country (CountryMorality Bool) → Country Int
summariseCountry = fmap totalMorality

totalMorality ∷ CountryMorality Bool → Int
totalMorality CountryMorality {
    capitalPunishment = cp',
    genderEquality = ge',
    sexualityEquality = se'
} = capitalPunishment moralityWeightings * fromEnum cp' +
    genderEquality moralityWeightings * fromEnum ge' +
    sexualityEquality moralityWeightings * fromEnum se'

main ∷ IO ()
main = print $ summariseCountry <$> countryData
