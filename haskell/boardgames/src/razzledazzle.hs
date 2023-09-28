import Control.Monad
import Control.Monad.HT           qualified as M
import Control.Monad.Loops
import Data.Maybe
import Numeric.Probability.Object
import Numeric.Probability.Random (run)
import Rando
-- import System.Random

type Score = Int
-- type Budget = Int
type Money = Int
data HasPrize = HasPrize | NoPrize deriving stock (Eq, Show)
data Yield = Yield | Winner | Continue deriving stock (Eq, Show)

-- Number of something, actual thing

boardNumbers ∷ [(Int, Double)]
boardNumbers = [(1,11/143),(2,18/143),(3,39/143),(4,44/143),(5,20/143),(6,11/143)]

diceNumbers ∷ [Int]
diceNumbers = [1..6]

makeResult ∷ IO Int → IO Result
makeResult a = fromJust . flip lookup boardPrizes . sum <$> replicateM 8 a

resDice ∷ IO Result
resDice = makeResult . pickOne $ diceNumbers

resMarbles ∷ IO Result
resMarbles = makeResult . run . fromFrequencies $ boardNumbers

data GameState = GameState {
    score  :: Score,
    prizes :: Int,
    money  :: Money, -- budget
    spent  :: Money,
    cost   :: Money,
    turns  :: Int,
    yield  :: Yield
} deriving stock (Show)

initialGameState ∷ GameState
initialGameState = GameState {
    score = 0,
    prizes = 0,
    money = 100000000000,
    spent = 0,
    cost = 1,
    turns = 0,
    yield = Continue
}

processRound ∷ GameState → IO Result → IO GameState
processRound gameState res = do
    result <- res
    pure $
        if money gameState > cost gameState then
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

processValidateRound ∷ GameState → IO Result → IO GameState
processValidateRound gameState res
    | money gameState == 0 = pure gameState
    | yield gameState == Yield = pure gameState
    | otherwise = processRound gameState res

processUntilFinish ∷ IO Result → GameState → IO GameState
processUntilFinish  = iterateUntilM (\ x -> yield x /= Continue) . flip processValidateRound
-- Scan ...


-- State? Random without IO?

data Result = Points Score | Prize | Zilch | PrizeAndPayDouble deriving stock (Show)

getPoints ∷ Result → Score
getPoints (Points x) = x
getPoints _          = 0

getPrize ∷ Result → HasPrize
getPrize Prize             = HasPrize
getPrize PrizeAndPayDouble = HasPrize
getPrize _                 = NoPrize

getPrizeIncrement ∷ HasPrize → Int
getPrizeIncrement NoPrize  = 0
getPrizeIncrement HasPrize = 1

getCost ∷ Result → Money → Money
getCost PrizeAndPayDouble m = 2 * m
getCost _ m                 = m

boardPrizes ∷ [(Int, Result)]
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

game ∷ IO Result → IO GameState
game = flip processUntilFinish initialGameState

main ∷ IO ()
main = do
    putStrLn "Dice version"
    game resDice >>= print
    M.until (\x -> yield x == Winner) (game resDice) >>= print
    putStrLn "Marbles version"
    game resMarbles >>= print
    M.until (\x -> yield x == Winner) (game resMarbles) >>= print
