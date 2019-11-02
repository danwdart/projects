module Lib.Game.Monopoly.Helpers where

import Lib.Game.Monopoly.Board
import Lib.Game.Monopoly.Game
import Lib.Game.Monopoly.Player
import Lib.Game.Monopoly.Space
import Lib.Game.Monopoly.Tax

playerSpace :: [Space] -> Player -> Space
playerSpace spaces player = spaces !! (position player)

processLand :: Player -> Board -> Space -> IO (Player, Board)
processLand player board space = case space of
        GoSpace -> do
            putStrLn "You win some money."
            let player' = addMoney 200 player
            return (player', board)
        PropertySpace p -> do
            putStrLn $ "Unimplemented: " ++ show p
            return (player, board)
        RandomSpace t -> do
            putStrLn $ "Unimplemented: " ++ show t
            return (player, board)
        StationSpace s -> do
            putStrLn $ "Unimplemented: " ++ show s
            return (player, board)
        UtilitySpace u -> do
            putStrLn $ "Unimplemented: " ++ show u
            return (player, board)
        TaxSpace t -> do
            putStrLn "You hit the tax space!"
            let (player', board') = taxMoney t player board
            return (player', board')
        JailSpace -> do
            putStrLn "You are in jail."
            return (player, board)
        JustVisitingSpace -> do
            putStrLn "Just visiting right now..."
            return (player, board)
        FreeParkingSpace -> do
            putStrLn "You receive all of the money."
            return (player, board)
        GoToJailSpace -> do
            putStrLn "You must go to jail now."
            return (player, board)

addMoney :: Int -> Player -> Player
addMoney income player = player {money = money player + income}

taxMoney :: Tax -> Player -> Board -> (Player, Board)
taxMoney (Tax _ fee) player board = (player {money = money player - fee}, board {freeParkingMoney = freeParkingMoney board + fee})