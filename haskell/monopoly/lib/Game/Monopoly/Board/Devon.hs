module Game.Monopoly.Board.Devon where

import Game.Monopoly.Board

devonBoard :: Board
devonBoard = Board [
    GoSpace,
    emptyPropertySpace Brown "Hayedown, Tavistock" 60,
    RandomSpace CommunityChest,
    emptyPropertySpace Brown "Lundy Island" 60,
    taxSpace "Income Tax" 200,
    stationSpace "The Port of Teignmouth",
    emptyPropertySpace LightBlue "Compton Castle, Marldon" 100,
    RandomSpace Chance,
    emptyPropertySpace LightBlue "Okehampton, Dartmoor" 100,
    emptyPropertySpace LightBlue "Combe Martin, Exmoor" 120,
    -- The normal jail space isn't achievable except under special circumstances.
    JustVisitingSpace,
    emptyPropertySpace Pink "Plainmoor" 140,
    utilitySpace "Electric Company",
    emptyPropertySpace Pink "St James' Park, Exeter" 140,
    emptyPropertySpace Pink "Plymouth Argyle, ???" 160,
    stationSpace "Grand Western Canal",
    emptyPropertySpace Orange "Barton Hill Road, Torquay" 180,
    RandomSpace CommunityChest,
    emptyPropertySpace Orange "????" 180,
    emptyPropertySpace Orange "????" 200,
    FreeParkingSpace,
    emptyPropertySpace Red "Sidmouth" 220,
    RandomSpace Chance,
    emptyPropertySpace Red "Budleigh Salterton" 220,
    emptyPropertySpace Red "??????" 240,
    stationSpace "Okehampton Station",
    emptyPropertySpace Yellow "Powderham Castle, ???" 260,
    emptyPropertySpace Yellow "The Landmark Theatre, Ilfracombe" 260,
    utilitySpace "Water Works",
    emptyPropertySpace Yellow "Boutport Street, Barnstaple" 280,
    GoToJailSpace,
    emptyPropertySpace Green "County Hall, Exeter" 300,
    emptyPropertySpace Green "Drake Circus, Plymouth" 300,
    RandomSpace CommunityChest,
    emptyPropertySpace Green "The Queen's Drive, Exeter" 320,
    stationSpace "Tarka Trail",
    RandomSpace Chance,
    emptyPropertySpace DarkBlue "Widecombe-in-the-Moor" 350,
    taxSpace "Bank Deposit" 100,
    emptyPropertySpace DarkBlue "Exeter Cathedral" 400
    ] 0