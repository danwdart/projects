module Game.Monopoly.Space where

import           Game.Monopoly.Colour
import           Game.Monopoly.Property
import           Game.Monopoly.Random
import           Game.Monopoly.Station
import           Game.Monopoly.Tax
import           Game.Monopoly.Utility

data Space = GoSpace
    | PropertySpace Property
    | RandomSpace RandomType
    | StationSpace Station
    | UtilitySpace Utility
    | TaxSpace Tax
    | JailSpace
    | JustVisitingSpace
    | FreeParkingSpace
    | GoToJailSpace deriving stock (Eq)

instance Show Space where
    show GoSpace           = "GO"
    show (PropertySpace p) = show p
    show (RandomSpace r)   = show r
    show (StationSpace s)  = show s
    show (UtilitySpace u)  = show u
    show (TaxSpace t)      = show t
    show JailSpace         = "In Jail"
    show JustVisitingSpace = "Just Visiting"
    show FreeParkingSpace  = "Free Parking"
    show GoToJailSpace     = "Go To Jail"

emptyPropertySpace ∷ Colour → String → Int → Space
emptyPropertySpace c s p = PropertySpace $ emptyProperty c s p

stationSpace ∷ String → Space
stationSpace n = StationSpace $ Station n

utilitySpace ∷ String → Space
utilitySpace n = UtilitySpace $ Utility n

taxSpace ∷ String → Int → Space
taxSpace n p = TaxSpace $ Tax n p
