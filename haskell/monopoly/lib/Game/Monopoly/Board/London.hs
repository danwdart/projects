module Game.Monopoly.Board.London where

import Game.Monopoly.Board
import Game.Monopoly.Colour
import Game.Monopoly.Random
import Game.Monopoly.Space

londonBoard ∷ Board
londonBoard = Board [
    GoSpace,
    emptyPropertySpace Brown "Old Kent Road" 60,
    RandomSpace CommunityChest,
    emptyPropertySpace Brown "Whitechapel Road" 60,
    taxSpace "Income Tax" 200,
    stationSpace "King's Cross Station",
    emptyPropertySpace LightBlue "The Angel Islington" 100,
    RandomSpace Chance,
    emptyPropertySpace LightBlue "Euston Road" 100,
    emptyPropertySpace LightBlue "Pentonville Road" 120,
    JustVisitingSpace,
    emptyPropertySpace Pink "Pall Mall" 140,
    utilitySpace "Electric Company",
    emptyPropertySpace Pink "Whitehall" 140,
    emptyPropertySpace Pink "Northumberland Avenue" 160,
    stationSpace "Marylebone Station",
    emptyPropertySpace Orange "Bow Street" 180,
    RandomSpace CommunityChest,
    emptyPropertySpace Orange "Marlborough Street" 180,
    emptyPropertySpace Orange "Vine Street" 200,
    FreeParkingSpace,
    emptyPropertySpace Red "Strand" 220,
    RandomSpace Chance,
    emptyPropertySpace Red "Fleet Street" 220,
    emptyPropertySpace Red "Trafalgar Square" 240,
    stationSpace "Fenchurch Street Station",
    emptyPropertySpace Yellow "Leicester Square" 260,
    emptyPropertySpace Yellow "Coventry Street" 260,
    utilitySpace "Water Works",
    emptyPropertySpace Yellow "Piccadilly" 280,
    GoToJailSpace,
    emptyPropertySpace Green "Regent Street" 300,
    emptyPropertySpace Green "Oxford Street" 300,
    RandomSpace CommunityChest,
    emptyPropertySpace Green "Bond Street" 320,
    stationSpace "Liverpool Street Station",
    RandomSpace Chance,
    emptyPropertySpace DarkBlue "Park Lane" 350,
    taxSpace "Super Tax" 100,
    emptyPropertySpace DarkBlue "Mayfair" 400
    ] 0
