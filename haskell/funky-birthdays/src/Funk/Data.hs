module Funk.Data (times, people) where

import Data.DateTime (fromGregorian)
import Funk.Constants (secondsInDay)
import Funk.Conversion (daysToSeconds, yearsToSeconds)
import Funk.Ranges (upToMax)
import Funk.Round (roundNumbers)
import Funk.Types (Row, PersonData)


times :: [Row]
times = [
    ("Seconds", 1, roundNumbers),
    ("Minutes", 60, roundNumbers),
    ("Hours", 3600, roundNumbers),
    ("Days", secondsInDay, roundNumbers),
    ("Weeks", 7 * secondsInDay, roundNumbers),
    ("Sidereal Years",  31558150, upToMax),
    ("Average Calendar Years", 31556952, upToMax),
    ("Common Calendar Years", 31536000, upToMax),
    ("Julian Astronomical Years", 31557600, upToMax),
    ("Leap Calendar Years", 31622400, upToMax),
    ("Average Draconitic Months", daysToSeconds 27.212220815, roundNumbers),
    ("Average Tropical Months", daysToSeconds 27.321582252, roundNumbers),
    ("Average Sidereal Months", daysToSeconds 27.321661554, roundNumbers),
    ("Average Anomalistic Months", daysToSeconds 27.554549886, roundNumbers),
    ("Average Synodic Months", daysToSeconds 29.530588861, roundNumbers),
    ("Cyllenian (Mercurian) Days", daysToSeconds 58.6, roundNumbers),
    ("Cyllenian (Mercurian) Years", daysToSeconds 87.97, roundNumbers),
    ("Cytherean / Luciferian (Venusian) Days", daysToSeconds 243, roundNumbers),
    ("Cytherean / Luciferian (Venusian) Years", daysToSeconds 224.7, roundNumbers),
    ("Martian / Arean Days", daysToSeconds 1.03, roundNumbers),
    ("Martian / Arean Years", yearsToSeconds 1.88, roundNumbers),
    ("Jovian, or Zeusian Days", daysToSeconds 0.41, roundNumbers),
    ("Jovian, or Zeusian Years", yearsToSeconds 11.86, roundNumbers),
    ("Cronian (Saturnian or Saturnial) Days", daysToSeconds 0.45, roundNumbers),
    ("Cronian (Saturnian or Saturnial) Years", yearsToSeconds 29.46, roundNumbers),
    ("Caelian (Uranian) Days", daysToSeconds 0.72, roundNumbers),
    ("Caelian (Uranian) Years", yearsToSeconds 84.01, roundNumbers),
    ("Poseidean (Neptunian) Days", daysToSeconds 0.67, roundNumbers),
    ("Poseidean (Neptunian) Years", yearsToSeconds 164.79, roundNumbers)
    ]
    
people :: [PersonData]
people = [
    ("Dan", fromGregorian 1991 6 4 1 20 0),
    ("Colin", fromGregorian 1991 6 10 0 0 0),
    ("Kaychan", fromGregorian 1992 11 18 23 0 0)
    ]