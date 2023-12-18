module Main (main) where

import Control.Monad
import Data.Set              qualified as Set
import Game.Monopoly.Board
import Game.Monopoly.Colour
import Game.Monopoly.Game
import Game.Monopoly.Helpers
import Game.Monopoly.Player
import Game.Monopoly.Random
import Game.Monopoly.Rules
import Game.Monopoly.Space
import Game.Monopoly.Token
import System.Random

-- data Round =
_londonBoard :: Board
_londonBoard = Board [
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

myGame ∷ Game
myGame = Game
    devonBoard
    [
        newPlayer "Bob" TopHat,
        newPlayer "Jim" Dog
    ] (
        ExtraRules (
            Set.fromList [HitGoExactlyReceive400, FreeParkingMoney, ThrowThreeDoublesGoToJail]
        )
    )

performRound ∷ Game → IO Game
performRound (Game b pl r) = do
    putStrLn "Let's go!"
    -- let numSpaces = length (spaces board)
    players' <- forM pl $ \p -> do
        putStrLn $ name p <> (" (the " <> (show (token p) <> (") is on " <> show (playerSpace (spaces b) p))))
        roll <- (,) <$> randomRIO (1, 6) <*> randomRIO (1, 6) :: IO (Int, Int)
        -- let total = roll <&> uncurry (+)
        putStrLn $ "Roll: " <> show roll
        let total = uncurry (+) roll
        putStrLn $ "Total: " <> show total
        let newPosition = position p + total
        --when (newPosition > numSpaces) $ do
        --   print "Passed GO."
        let p' = p {position = newPosition}
        let newSpace = spaces b !! newPosition
        putStrLn $ "That puts you on position " <> (show newPosition <> (" which is " <> show newSpace))
        (_, _) <- processLand p' b newSpace
        -- board'
        pure p'

    pure $ Game b players' r

main ∷ IO ()
main = do
    myGame1 <- performRound myGame
    myGame2 <- performRound myGame1
    print myGame2
    pure ()
