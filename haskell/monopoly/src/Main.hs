module Main (main) where

import Control.Monad
import Data.Set              qualified as Set
import Game.Monopoly.Board
import Game.Monopoly.Board.Devon
import Game.Monopoly.Colour
import Game.Monopoly.Dice
import Game.Monopoly.Game
import Game.Monopoly.Helpers
import Game.Monopoly.Player
import Game.Monopoly.Random
import Game.Monopoly.Rules
import Game.Monopoly.Space
import Game.Monopoly.Token
import System.Random

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
performRound (Game board' players' rules') = do
    putStrLn "Let's go!"
    -- let numSpaces = length (spaces board)
    newPlayers' <- forM players' $ \player' -> do
        putStrLn $ name player' <> (" (the " <> (show (token player') <> (") is on " <> show (playerSpace (spaces board') player'))))
        (roll, isDouble) <- randomRoll
        putStrLn $ "Roll: " <> show roll
        let newPosition = position player' + roll
        --when (newPosition > numSpaces) $ do
        --   print "Passed GO."
        let newPlayer' = p { position = newPosition }
        let newSpace = spaces board' !! newPosition
        putStrLn $ "That puts you on position " <> (show newPosition <> (" which is " <> show newSpace))
        (_, _) <- processLand newPlayer' board' newSpace
        -- board'
        pure player'

    pure $ Game board' newPlayers' rules'

main ∷ IO ()
main = do
    myGame1 <- performRound myGame
    myGame2 <- performRound myGame1
    print myGame2
    pure ()
