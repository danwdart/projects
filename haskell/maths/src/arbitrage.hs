module Main where

import           Data.Ratio

{-# ANN module "HLint: ignore Avoid restricted function" #-}

newtype Bookmaker = Bookmaker String
    deriving stock (Show, Eq)

type Competitor = String
type Odds = Rational
type Money = Int

type Choice = (Competitor, Odds)

data GambleData = GambleData {
    bookmaker :: Bookmaker,
    choices   :: [Choice]
} deriving stock (Show, Eq)

data Bet = Bet {
    choice :: Competitor,
    amount :: Money
} deriving stock (Show, Eq)

newtype Answer = Answer {
    getBets :: Maybe [Bet]
} deriving stock (Show, Eq)


-- A win can only be guaranteed by ensuring the recoprocal odds  for all the choices together sum to make <1.
-- Then, the maximal win is proportional to the input value times the reciprocal odds.

calculateAnswer ∷ Int → [GambleData] → Answer
calculateAnswer _ [] = Answer Nothing -- No data? No bets!
calculateAnswer _ _  = undefined

expandGambleData ∷ GambleData → [(Bookmaker, (Competitor, Odds))]
expandGambleData gd = fmap (\(competitor', odds') -> (bookmaker gd, (competitor', odds'))) . choices $ gd

getAllCombinations ∷ [[(Bookmaker, (Competitor, Odds))]] → [[(Bookmaker, (Competitor, Odds))]]
getAllCombinations = undefined
-- findOkayCombination =

-- Simulation

newtype Bank = Bank {
    money :: Money
} deriving stock (Show)

demoData ∷ [GambleData]
demoData = [
    GambleData (Bookmaker "Evil Joe's") [("Bobby", 1 % 5), ("Evil Jimmy", 2 % 15), ("George", 3 % 5)],
    GambleData (Bookmaker "Evil Sam's") [("Bobby", 2 % 5), ("Evil Jimmy", 7 % 16), ("George", 2 % 5)],
    GambleData (Bookmaker "Evil Paddy's") [("Bobby", 1 % 5), ("Evil Jimmy", 3 % 10), ("George", 1 % 5)]
    ]

generateBookies ∷ IO [GambleData]
generateBookies = do
    pure demoData

initialInvestment ∷ Money
initialInvestment = 100

main ∷ IO ()
main = pure ()
