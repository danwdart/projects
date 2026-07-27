module Main where

import Control.Monad.Random

main :: IO ()
main = do
    putStrLn "== EU =="
    let amountWageredEU :: Int = 1
    -- putStrLn "= Amount wagered:"
    -- print amountWageredEU
    wagersEU <- replicateM amountWageredEU $ uniform euOptionsPayouts -- for now one for each
    -- putStrLn "= Your wager choices:"
    -- print wagersEU
    -- let meanWinningsOverAllEU = meanWinnings euOptionsPayouts euResults
    -- putStrLn "= The mean winnings all over of all options"
    -- print meanWinningsOverAllEU
    -- putStrLn "= The price of all options"
    -- print $ length euOptionsPayouts
    -- putStrLn "= The mean profit of all options"
    -- print $ meanWinningsOverAllEU - fromIntegral (length euOptionsPayouts)
    let meanWinningsEU = meanWinnings wagersEU euResults
    -- putStrLn "= The mean winnings your choices could have gotten you"
    -- print meanWinningsEU
    putStrLn "= The mean profit your choices could have gotten you"
    print @Rational $ meanWinningsEU - fromIntegral amountWageredEU
    -- resultEU <- uniform euResults
    -- putStrLn "= Your ball result"
    -- print resultEU
    -- putStrLn "= Your winning options"
    -- print $ showWinningResults wagersEU resultEU
    -- let totalWinningsEU = calculateWinnings wagersEU resultEU
    -- putStrLn "= Your winnings"
    -- print totalWinningsEU
    -- let netProfitEU = totalWinningsEU - amountWageredEU
    -- putStrLn "= Your net profit"
    -- print netProfitEU

    putStrLn "== US =="
    let amountWageredUS :: Int = 1
    -- putStrLn "= Amount wagered:"
    -- print amountWageredUS
    wagersUS <- replicateM amountWageredUS $ uniform usOptionsPayouts -- for now one for each
    -- putStrLn "= Your wager choices:"
    -- print wagersUS
    -- let meanWinningsOverAllUS = meanWinnings usOptionsPayouts usResults
    -- putStrLn "= The mean winnings all over of all options"
    -- print meanWinningsOverAllUS
    -- putStrLn "= The price of all options"
    -- print $ length usOptionsPayouts
    -- putStrLn "= The mean profit of all options"
    -- print $ meanWinningsOverAllUS - fromIntegral (length usOptionsPayouts)
    let meanWinningsUS = meanWinnings wagersUS usResults
    -- putStrLn "= The mean winnings your choices could have gotten you"
    -- print meanWinningsUS
    putStrLn "= The mean profit your choices could have gotten you"
    print @Rational $ meanWinningsUS - fromIntegral amountWageredUS
    -- resultUS <- uniform usResults
    -- putStrLn "= Your ball result"
    -- print resultUS
    -- putStrLn "= Your winning options"
    -- print $ showWinningResults wagersUS resultUS
    -- let totalWinningsUS = calculateWinnings wagersUS resultUS
    -- putStrLn "= Your winnings"
    -- print totalWinningsUS
    -- let netProfitUS = totalWinningsUS - amountWageredUS
    -- putStrLn "= Your net profit"
    -- print netProfitUS

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
calculateWinnings opts res = {- traceShow (
    "Winnings",
    sum . fmap ((+ 1) . snd) $ showWinningResults opts res,
    "Winning amounts each",
    fmap ((+ 1) . snd) $ showWinningResults opts res,
    "Number of winning results",
    length (showWinningResults opts res),
    "Winning results",
    showWinningResults opts res,
    "Options",
    opts,
    "Result",
    res
    ) $ -} sum . fmap ((+ 1) . snd) $ showWinningResults opts res-- the +1 is when you keep what you wagered

mean :: Fractional a => [a] -> a
mean xs = sum xs / fromIntegral (length xs)

meanWinnings :: Fractional a => [([Result], Payout)] -> [Result] -> a
meanWinnings opts results = {- traceShow (
    "Mean winnings",
    (mean $ fmap (fromIntegral . calculateWinnings opts) results) :: Double,
    "Winnings in question",
    fmap (calculateWinnings opts) results :: [Int],
    "Total winnings",
    sum $ fmap (calculateWinnings opts) results :: Int,
    "Number of options of winnings",
    length $ fmap (calculateWinnings opts) results :: Int,
    "Average winnings",
    (fromIntegral $ sum $ fmap (calculateWinnings opts) results :: Double) / (fromIntegral $ length $ fmap (calculateWinnings opts) results :: Double) :: Double,
    "Results in question"
    -- results
    ) $ -} mean $ fmap (fromIntegral . calculateWinnings opts) results 