module Funk.Ranges (upToMax) where

import Funk.Types (DayOfInterest)

maxForOne :: DayOfInterest
maxForOne = 1000

upToMax :: [DayOfInterest]
upToMax = [1..maxForOne]