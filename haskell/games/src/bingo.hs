import Control.Monad.Error
import Control.Monad.State
import System.Random.Shuffle (shuffleM)

main :: IO ()
main = pure ()

data Combo = Corner | LinesOfLength Int Int

data LineConfig = LineConfig {
    lines :: Int,
    numbersPerLine :: Int,
}

data WinningCombo = WinningCombo {
    corners :: Bool, -- are we doing four corners
    diagonals :: Bool,
    horizontalLines :: Maybe LineConfig,
    verticalLines :: Maybe LineConfig
}

data Ruleset = Ruleset {
    pool :: Int,
    rows :: Int,
    colSetup :: [(Int, Int)] -- for each col, number choices from a to b
    freeSpaces :: [(Int, Int)], -- x, y for each free space
    winningCombo :: WinningCombo
}

defaultRulesForCombo :: WinningCombo -> Ruleset
defaultRulesForCombo = Ruleset 90 3 [(1,10),(11,20),(21,30),(31,40),(41,50),(51,60),(61,70),(71,80),(81,90)] [] 4

comboFourCorners :: WinningCombo
comboFourCorners = WinningCombo {
    corners = True,
    diagonals = False,
    horizontalLines = Nothing,
    verticalLines = Nothing
}

comboOneLine :: WinningCombo
comboOneLine = WinningCombo {
    corners = False,
    diagonals = False,
    horizontalLines = Just (1, 5, 4),
    verticalLines = Nothing
}

comboTwoLines :: WinningCombo
comboTwoLines = WinningCombo {
    corners = False,
    diagonals = False,
    horizontalLines = Just (2, 5, 4),
    verticalLines = Nothing
}

comboNZSuperHousie :: WinningCombo
comboNZSuperHousie = WinningCombo {
    corners = False,
    diagonals = False,
    horizontalLines = Just (1, 5, 4),
    verticalLines = Nothing
}

comboFullHouse :: WinningCombo

rulesUS :: Ruleset
rulesUS = Ruleset {
    pool = 75,
    rows = 5,
    colSetup = [(1,15),(16,30),(31,45),(46,60),(61,75)],
    freeSpaces = [(2,2)],
    winningCombo = WinningCombo {
        corners = False,
        diagonals = True,
        horizontalLines = Just (1, 5),
        verticalLines = Just (1, 5)
    }
}


type ErrorMessage = String

type NumOnCard = (Int, Bool)

-- Take one random unique value from a state of list of them and keep the rest.
takeS :: (MonadState [a] m, MonadError ErrorMessage m) => m a
takeS = do
    -- TODO deal with the error state
    emptyList <- gets null
    when emptyList $ throwError "Empty list"
    a <- gets head -- (a:as) <- get
    modify tail -- put as
    pure a

-- Take n random unique values from a list of a to b.
takeNS :: (MonadState [a] m, MonadError ErrorMessage m) => Int -> m [a]
takeNS = replicateM

-- Generate a column.
genRandomCol4 :: MonadRandom m => m [NumOnCard]
genRandomCol4 = fmap (, False) . take 2 <$> shuffleM [31..45] <>
    [(0, True)] <>
    fmap (, False) . take 2 <$> shuffleM [31..45]

genRandomCol5 :: MonadRandom m => Int -> m [NumOnCard]
genRandomCol5 col = fmap (, False) . take 5 <$> shuffleM [((col - 1) * 15 + 1)..(col * 15)] -- kak but efficient

-- Generate a card.
genRandomCard :: MonadRandom m => m [[NumOnCard]]
genRandomCard = do
    -- TODO tersify
    col1 <- genRandomCol5 1
    col2 <- genRandomCol5 2
    col3 <- genRandomCol4
    col4 <- genRandomCol5 4
    col5 <- genRandomCol5 5
    pure [col1, col2, col3, col4, col5]

-- Mark a card.

markCard :: Int -> [[NumOnCard]]
markCard n = fmap (fmap (\x -> if fst x == n then (n, True) else x ))

-- Check if a card has won.

checkHWin :: [[NumOnCard]] -> Bool
checkHWin = undefined

checkVWin :: [[NumOnCard]] -> Bool
checkVWin = undefined

checkDWin :: [[NumOnCard]] -> Bool
checkDWin = undefined

-- Generate a player.

-- Generate a number of players

-- Mark all cards

-- Randomise the balls.

-- Take a ball from a list.

-- Run one round.

-- Run the game to completion.