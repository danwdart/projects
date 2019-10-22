module Funk.Conversion (daysToSeconds, yearsToSeconds) where

import Funk.Constants (secondsInDay, secondsInYear)

daysToSeconds, yearsToSeconds :: Double -> Integer
daysToSeconds d = round (d * fromInteger secondsInDay)
yearsToSeconds d = round (d * fromInteger secondsInYear)