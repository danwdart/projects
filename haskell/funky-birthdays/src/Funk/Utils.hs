module Funk.Utils (untilEnd) where

import Data.DateTime
import Data.List (sortOn)
import Data.Time
import Funk.Constants (secondsInYear)
import Funk.Data (people, times)
import Funk.Types (DateNameTime (..))

filterDays :: UTCTime -> UTCTime -> [DateNameTime] -> [DateNameTime]
filterDays fromDay untilDay = takeWhile ((<= untilDay) . time) . dropWhile ((<= fromDay) . time)

birthTimes :: [DateNameTime]
birthTimes = do
    (name, bdtime) <- people

    (timename, secs, numbers) <- times
    number <- numbers

    return $ DateNameTime (name ++ ": " ++ show number ++ " " ++ timename) (addSeconds (number * secs) bdtime)

untilEnd :: UTCTime -> [String]
untilEnd now = do
    end <- filterDays now (addSeconds (5 * secondsInYear) now) (sortOn time birthTimes)
    return $ show end
