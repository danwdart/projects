module Funk.Utils (untilEnd) where

import Data.DateTime
import Data.List (sortOn)
import Data.Time
import Funk.Constants (secondsInYear)
import Funk.Data (people, times)
import Funk.Types (DateNameTime)

filterDays :: UTCTime -> UTCTime -> [DateNameTime] -> [DateNameTime]
filterDays fromDay untilDay = takeWhile ((<= untilDay) . snd) . dropWhile ((<= fromDay) . snd)

birthTimes :: [DateNameTime]
birthTimes = do
    (name, bdtime) <- people

    (timename, secs, numbers) <- times
    number <- numbers

    return (name ++ ": " ++ show number ++ " " ++ timename, addSeconds (number * secs) bdtime)

untilEnd :: UTCTime -> [DateNameTime]
untilEnd now = do
    filterDays now (addSeconds (5 * secondsInYear) now) (sortOn snd birthTimes)
