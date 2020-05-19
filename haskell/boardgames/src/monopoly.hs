{-# LANGUAGE UnicodeSyntax #-}
import           Control.Monad
import qualified Data.Set                  as Set

import           Lib.Game.Monopoly.Board
import           Lib.Game.Monopoly.Colour
import           Lib.Game.Monopoly.Game
import           Lib.Game.Monopoly.Helpers
import           Lib.Game.Monopoly.Player
import           Lib.Game.Monopoly.Random
import           Lib.Game.Monopoly.Rules
import           Lib.Game.Monopoly.Space
import           Lib.Game.Monopoly.Token

import           System.Random

-- data Round =

myGame ∷ Game
myGame = Game
    (
        Board [
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
        ]
        0
    )
    [
        newPlayer "Bob" TopHat,
        newPlayer "Jim" Dog
    ] (
        ExtraRules (
            Set.fromList [HitGoExactlyReceive400, FreeParkingMoney]
        )
    )

performRound ∷ Game → IO Game
performRound (Game b pl r) = do
    putStrLn "Let's go!"
    -- let numSpaces = length (spaces board)
    players' <- forM pl $ \p -> do
        putStrLn $ name p ++ " (the " ++ show (token p) ++ ") is on " ++ show (playerSpace (spaces b) p)
        roll <- (,) <$> randomRIO (1, 6) <*> randomRIO (1, 6) :: IO (Int, Int)
        -- let total = roll <&> uncurry (+)
        putStrLn $ "Roll: " ++ show roll
        let total = uncurry (+) roll
        putStrLn $ "Total: " ++ show total
        let newPosition = position p + total
        --when (newPosition > numSpaces) $ do
        --   print "Passed GO."
        let p' = p {position = newPosition}
        let newSpace = spaces b !! newPosition
        putStrLn $ "That puts you on position " ++ show newPosition ++ " which is " ++ show newSpace
        (_, _) <- processLand p' b newSpace
        -- board'
        return p'

    return $ Game b players' r

main ∷ IO ()
main = do
    myGame1 <- performRound myGame
    myGame2 <- performRound myGame1
    print myGame2
    return ()
