{-# LANGUAGE UnicodeSyntax #-}
module Lib.Game.Monopoly.Helpers where

import           Lib.Game.Monopoly.Board
import           Lib.Game.Monopoly.Player
import           Lib.Game.Monopoly.Space
import           Lib.Game.Monopoly.Tax

playerSpace ∷ [Space] → Player → Space
playerSpace s player = s !! position player

processLand ∷ Player → Board → Space → IO (Player, Board)
processLand player b space = case space of
        GoSpace -> do
            putStrLn "You win some money."
            let player' = addMoney 200 player
            return (player', b)
        PropertySpace p -> do
            putStrLn $ "Unimplemented: " ++ show p
            return (player, b)
        RandomSpace t -> do
            putStrLn $ "Unimplemented: " ++ show t
            return (player, b)
        StationSpace s -> do
            putStrLn $ "Unimplemented: " ++ show s
            return (player, b)
        UtilitySpace u -> do
            putStrLn $ "Unimplemented: " ++ show u
            return (player, b)
        TaxSpace t -> do
            putStrLn "You hit the tax space!"
            let (player', b') = taxMoney t player b
            return (player', b')
        JailSpace -> do
            putStrLn "You are in jail."
            return (player, b)
        JustVisitingSpace -> do
            putStrLn "Just visiting right now..."
            return (player, b)
        FreeParkingSpace -> do
            putStrLn "You receive all of the money."
            return (player, b)
        GoToJailSpace -> do
            putStrLn "You must go to jail now."
            return (player, b)

addMoney ∷ Int → Player → Player
addMoney income player = player {money = money player + income}

taxMoney ∷ Tax → Player → Board → (Player, Board)
taxMoney (Tax _ fee) player b = (player {money = money player - fee}, b {freeParkingMoney = freeParkingMoney b + fee})
