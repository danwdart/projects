module MyLens.Date where

import MyLens

data Date = Date {
    _year  :: Int,
    _month :: Int,
    _day   :: Int
} deriving (Show)

year ∷ Lens' Date Int
year = lens _year (\date year' -> date { _year = year'})

month ∷ Lens' Date Int
month = lens _month (\date month' -> date { _month = month'})

day ∷ Lens' Date Int
day = lens _day (\date day' -> date { _day = day'})
