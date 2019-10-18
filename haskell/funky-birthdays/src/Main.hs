module Main where

import Data.DateTime as DT
import Data.Time as T

daysInWeek = 7
daysInYear = 365

maxAge = 100

addYears :: Integer -> Day -> Day
addYears n = addDays (daysInYear * n)

addWeeks n = addDays (daysInWeek * n)

filterDays fromDay untilDay = takeWhile ((<= untilDay) . snd) . dropWhile ((<= fromDay) . snd)

roundLookingNumbers = (*) <$> [10 ^ n | n <- [0..10]] <*> [1..10]

main :: IO ()
main = do
    let bdtime = DT.fromGregorian 1991 6 4 1 20 0

    let bday = utctDay bdtime

    now <- DT.getCurrentTime

    let today = utctDay now

    let untilDay = addYears maxAge bday

    -- let numbersOfDays = [n * 100 | n <- [1..1000]]

    let birthdays = (\days -> (days, addDays days bday)) <$> roundLookingNumbers

    let until100 = filterDays today untilDay birthdays

    mapM_ print until100