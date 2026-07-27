module Main where

import Control.Monad.Random

main :: IO ()
main = do
    let amountWageredEU :: Int = 5
    wagersEU <- replicateM amountWageredEU $ uniform euOptionsPayouts -- for now one for each
    print wagersEU
    resultEU <- uniform euResults
    print resultEU
    print $ showWinningResults wagersEU resultEU
    let totalWinningsEU = calculateWinnings wagersEU resultEU
    print totalWinningsEU
    let netProfitEU = totalWinningsEU - amountWageredEU
    print netProfitEU

    let amountWageredUS :: Int = 5
    wagersUS <- replicateM amountWageredUS $ uniform usOptionsPayouts -- for now one for each
    print wagersUS
    resultUS <- uniform usResults
    print resultUS
    print $ showWinningResults wagersUS resultUS
    let totalWinningsUS = calculateWinnings wagersUS resultUS
    print totalWinningsUS
    let netProfitUS = totalWinningsUS - amountWageredUS
    print netProfitUS

-- Available results
type Result = String
type Payout = Int
type Bet = Int

usResults :: [Result]
usResults = ["00"] <> fmap (show @Int) [0..36]

euResults :: [Result]
euResults = fmap (show @Int) [0..36]

usOptionsPayouts :: [([Result], Payout)]
usOptionsPayouts = concatMap (\res -> [([res], 35)]) usResults <> 
    -- Twos
    concatMap (\results -> [(results, 17)]) ([
        ["00", "0"],
        ["00", "2"],
        ["00", "3"],
        ["0", "1"],
        ["0", "2"],
        ["34", "35"],
        ["35", "36"]
        ] <> concatMap (\row -> [
            [show @Int row, show @Int (row + 1)],
            [show @Int row, show @Int (row + 3)],
            [show @Int (row + 1), show @Int (row + 2)],
            [show @Int (row + 1), show @Int (row + 4)],
            [show @Int (row + 2), show @Int (row + 5)]
        ]) [1,4..31]
    )
    <>
    -- Threes
    concatMap (\results -> [(results, 11)]) (
        fmap (\row -> [show @Int row, show @Int (row + 1), show @Int (row + 2)]) [1,4..34]) <>
    -- Fours
    concatMap (\results -> [(results, 8)]) (
        concatMap (\row -> [
            [show @Int row, show @Int (row + 1), show @Int (row + 3), show @Int (row + 4)],
            [show @Int (row + 1), show @Int (row + 2), show @Int (row + 4), show @Int (row + 5)]
            ]) [1,4..31]
    ) <>
    -- Fives
    [
        (["00", "0", "1", "2", "3"], 7)
    ] <>
    -- Sixes
    concatMap (\results -> [(results, 5)]) (
        fmap (\row -> [show @Int row, show @Int (row + 1), show @Int (row + 2), show @Int (row + 3), show @Int (row + 4), show @Int (row + 5)]) [1,7..31]) <>
    -- Dozens
    [
        (fmap (show @Int) [1..12], 2),
        (fmap (show @Int) [13..24], 2),
        (fmap (show @Int) [25..36], 2)
    ] <>
    -- Eighteens
    [
        -- First
        (fmap (show @Int) [1..18], 1),
        -- Second
        (fmap (show @Int) [19..36], 1),
        -- Even
        (fmap (show @Int . (* 2)) [1..18], 1),
        -- Odd
        (fmap (show @Int . (subtract 1) . (* 2)) [1..18], 1),
        -- Red = odds 1 to 9, evens 12 to 18, odds 19 to 27, evens 30 to 36
        (fmap (show @Int) ([1,3..9] <> [12,14..18] <> [19,21..27] <> [30,32..36]), 1),
        -- Black = evens 2 to 10, odds 11 to 17, evens 20 to 28, odds 29 to 35
        (fmap (show @Int) ([2,4..10] <> [11,13..17] <> [20,22..28] <> [29,31..35]), 1)
    ]

euOptionsPayouts :: [([Result], Payout)]
euOptionsPayouts = concatMap (\res -> [([res], 35)]) euResults <> 
    -- Twos
    concatMap (\results -> [(results, 17)]) ([
        ["0", "1"],
        ["0", "2"],
        ["0", "3"],
        ["34", "35"],
        ["35", "36"]
        ] <> concatMap (\row -> [
            [show @Int row, show @Int (row + 1)],
            [show @Int row, show @Int (row + 3)],
            [show @Int (row + 1), show @Int (row + 2)],
            [show @Int (row + 1), show @Int (row + 4)],
            [show @Int (row + 2), show @Int (row + 5)]
        ]) [1,4..31]
    )
    <>
    -- Threes
    concatMap (\results -> [(results, 11)]) (
        fmap (\row -> [show @Int row, show @Int (row + 1), show @Int (row + 2)]) [1,4..34]) <>
    -- Fours
    concatMap (\results -> [(results, 8)]) (
        concatMap (\row -> [
            [show @Int row, show @Int (row + 1), show @Int (row + 3), show @Int (row + 4)],
            [show @Int (row + 1), show @Int (row + 2), show @Int (row + 4), show @Int (row + 5)]
            ]) [1,4..31]
    ) <>
    -- Sixes
    concatMap (\results -> [(results, 5)]) (
        fmap (\row -> [show @Int row, show @Int (row + 1), show @Int (row + 2), show @Int (row + 3), show @Int (row + 4), show @Int (row + 5)]) [1,7..31]) <>
    -- Dozens
    [
        (fmap (show @Int) [1..12], 2),
        (fmap (show @Int) [13..24], 2),
        (fmap (show @Int) [25..36], 2)
    ] <>
    -- Eighteens
    [
        -- First
        (fmap (show @Int) [1..18], 1),
        -- Second
        (fmap (show @Int) [19..36], 1),
        -- Even
        (fmap (show @Int . (* 2)) [1..18], 1),
        -- Odd
        (fmap (show @Int . (subtract 1) . (* 2)) [1..18], 1),
        -- Red = odds 1 to 9, evens 12 to 18, odds 19 to 27, evens 30 to 36
        (fmap (show @Int) ([1,3..9] <> [12,14..18] <> [19,21..27] <> [30,32..36]), 1),
        -- Black = evens 2 to 10, odds 11 to 17, evens 20 to 28, odds 29 to 35
        (fmap (show @Int) ([2,4..10] <> [11,13..17] <> [20,22..28] <> [29,31..35]), 1)
    ]

euSetBets :: [([Result], Bet)]
euSetBets = []

usSetBets :: [([Result], Bet)]
usSetBets = []

showWinningResults :: [([Result], Payout)] -> Result -> [([Result], Payout)]
showWinningResults opts res = filter (\(results, _) -> res `elem` results) opts

calculateWinnings :: [([Result], Payout)] -> Result -> Payout
calculateWinnings opts res = sum . fmap snd . filter (\(results, _) -> res `elem` results) $ opts