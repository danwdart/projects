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
            -- @TODO check rule.
            let player' = addMoney 200 player
            pure (player', b)
        PropertySpace p -> do
            -- @TODO check rule. This is force.
            putStrLn $ "Unimplemented: " <> show p
            -- 1. Check owner
            -- 2. If owned, check house status.
            -- 3. If not owned
            -- 4. Check money
                -- a. No money -> if buy rule is auction then auction otherwise ignore
                -- b. Money ->
                    -- i. if buy rule is force then buy property
                    -- ii. if buy rule is not force then prompt
                        -- I. yes -> buy property
                        -- II. no -> if buy rule is auction then auction otherwise ignore
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
            putStrLn $ "You hit a tax space: " <> show t <> "!"
            let (player', b') = taxMoney t player b
            pure (player', b')
        JailSpace -> do
            putStrLn "You are in jail. You must throw three doubles to get out."
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
taxMoney (Tax _ fee) player b = (player {money = money player - fee}, b {_freeParkingMoney = _freeParkingMoney b + fee})
