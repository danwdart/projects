import Control.Monad
import Control.Monad.Loops
import qualified Control.Monad.HT as M
import Data.Maybe
import Rando
-- import System.Random

type Score = Int
-- type Budget = Int
type Money = Int
data HasPrize = HasPrize | NoPrize deriving (Eq, Show)
data Yield = Yield | Winner | Continue deriving (Eq, Show)

-- Number of something, actual thing

-- boardNumbers :: [(Int, Int)]
-- boardNumbers = [(1,11),(2,18),(3,39),(4,44),(5,20),(6,11)]

numberOfChoices :: Int
numberOfChoices = 8

diceNumbers :: [Int]
diceNumbers = [1..6]

rollDice :: IO [Int]
rollDice = replicateM numberOfChoices $ pickOne diceNumbers

sumDice :: IO Int
sumDice = sum <$> rollDice

resDice :: IO Result
resDice = fromJust . flip lookup boardPrizes <$> sumDice

data GameState = GameState {
    score :: Score,
    prizes :: Int,
    money :: Money, -- budget
    spent :: Money,
    cost :: Money,
    turns :: Int,
    yield :: Yield
} deriving (Show)

initialGameState :: GameState
initialGameState = GameState {
    score = 0,
    prizes = 0,
    money = 10000,
    spent = 0,
    cost = 1,
    turns = 0,
    yield = Continue
}

processRound :: GameState -> IO GameState
processRound gameState = do
    result <- resDice
    return $ if money gameState > cost gameState then
        GameState {
            score = score gameState + getPoints result,
            prizes = prizes gameState + getPrizeIncrement (getPrize result),
            money = money gameState - cost gameState,
            spent = spent gameState + cost gameState,
            cost = getCost result $ cost gameState,
            turns = turns gameState + 1,
            yield = if score gameState >= 100 then Winner else Continue
        }
    else
        gameState {
            yield = Yield
        }

processValidateRound :: GameState -> IO GameState
processValidateRound gameState
    | money gameState == 0 = return gameState
    | yield gameState == Yield = return gameState
    | otherwise = processRound gameState

processUntilFinish :: GameState -> IO GameState
processUntilFinish = iterateUntilM (\x -> yield x /= Continue) processValidateRound

-- Scan ...

-- State? Random without IO?

data Result = Points Score | Prize | Zilch | PrizeAndPayDouble deriving (Show)

getPoints :: Result -> Score
getPoints (Points x) = x
getPoints _ = 0

getPrize :: Result -> HasPrize
getPrize Prize = HasPrize
getPrize PrizeAndPayDouble = HasPrize
getPrize _ = NoPrize

getPrizeIncrement :: HasPrize -> Int
getPrizeIncrement NoPrize = 0
getPrizeIncrement HasPrize = 1

getCost :: Result -> Money -> Money
getCost PrizeAndPayDouble m = 2 * m
getCost _ m = m

boardPrizes :: [(Int, Result)]
boardPrizes = [
    (8, Points 100),
    (9, Points 100),
    (10, Points 50),
    (11, Points 30),
    (12, Points 50),
    (13, Points 50),
    (14, Points 20),
    (15, Points 15),
    (16, Points 10),
    (17, Points 5),
    (18, Prize),
    (19, Prize),
    (20, Prize),
    (21, Prize),
    (22, Zilch),
    (23, Zilch),
    (24, Zilch),
    (25, Zilch),
    (26, Zilch),
    (27, Zilch),
    (28, Zilch),
    (29, PrizeAndPayDouble),
    (30, Zilch),
    (31, Zilch),
    (32, Zilch),
    (33, Zilch),
    (34, Zilch),
    (35, Prize),
    (36, Prize),
    (37, Prize),
    (38, Prize),
    (39, Points 5),
    (40, Points 5),
    (41, Points 15),
    (42, Points 20),
    (43, Points 50),
    (44, Points 50),
    (45, Points 30),
    (46, Points 50),
    (47, Points 100),
    (48, Points 100)
    ]

game :: IO GameState
game = processUntilFinish initialGameState

main :: IO ()
main = do
    game >>= print
    M.until (\x -> yield x == Winner) game >>= print