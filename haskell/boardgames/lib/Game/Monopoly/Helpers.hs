module Game.Monopoly.Helpers where

import Game.Monopoly.Board
import Game.Monopoly.Player
import Game.Monopoly.Space
import Game.Monopoly.Tax

playerSpace ∷ [Space] → Player → Space
playerSpace s player = s !! position player

processLand ∷ Player → Board → Space → IO (Player, Board)
processLand player b space = case space of
        GoSpace -> do
            putStrLn "You win some money."
            let player' = addMoney 200 player
            pure (player', b)
        PropertySpace p -> do
            putStrLn $ "Unimplemented: " <> show p
            pure (player, b)
        RandomSpace t -> do
            putStrLn $ "Unimplemented: " <> show t
            pure (player, b)
        StationSpace s -> do
            putStrLn $ "Unimplemented: " <> show s
            pure (player, b)
        UtilitySpace u -> do
            putStrLn $ "Unimplemented: " <> show u
            pure (player, b)
        TaxSpace t -> do
            putStrLn "You hit the tax space!"
            let (player', b') = taxMoney t player b
            pure (player', b')
        JailSpace -> do
            putStrLn "You are in jail."
            pure (player, b)
        JustVisitingSpace -> do
            putStrLn "Just visiting right now..."
            pure (player, b)
        FreeParkingSpace -> do
            putStrLn "You receive all of the money."
            pure (player, b)
        GoToJailSpace -> do
            putStrLn "You must go to jail now."
            pure (player, b)

addMoney ∷ Int → Player → Player
addMoney income player = player {money = money player + income}

taxMoney ∷ Tax → Player → Board → (Player, Board)
taxMoney (Tax _ fee) player b = (player {money = money player - fee}, b {freeParkingMoney = freeParkingMoney b + fee})
