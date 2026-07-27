module Main where

main :: IO ()
main = do
    putStrLn "Running strategies..."

-- Given a list of probabilities, budget, granularity and the last results, give the best idea of what to bet next

type Option = String
type Probability = Rational
type StartingBudget = Int
type Pot = Int
type Bet = Int
type MinBet = Int
type MaxBet = Maybe Int
type Winnings = Int
type Granularity = Int
type History = [(Option, Bet, Winnings, Pot)]
type BetRules = (MinBet, MaxBet, Granularity)
type Strategy = StartingBudget -> Pot -> BetRules -> History -> Bet 

probs :: [(Option, Probability)]
probs = [("Heads", 499 / 1000), ("Tails", 499 / 1000), ("Edge", 1 / 500)]

startingBudget :: StartingBudget
startingBudget = 100

granularity :: Granularity
granularity = 1

minBet :: MinBet
minBet = 1

maxBet :: MaxBet
maxBet = Nothing

proportionOfPot :: a
proportionOfPot = 1 / 20

proportionOfStart :: a
proportionOfStart = 1 / 20

roundToNearest :: a -> a -> a
roundToNearest nearest num = nearest * round (num / nearest)

ceilingToNearest :: a -> a -> a
ceilingToNearest nearest num = nearest * ceiling (num / nearest)

floorToNearest :: a -> a -> a
floorToNearest nearest num = nearest * floor (num / nearest)

ceilingCapToNearest :: a -> a -> a -> a
ceilingCapToNearest = undefined

floorCapToNearest :: a -> a -> a -> a
floorCapToNearest = undefined

-- some silly easy ones

alwaysLowest :: Strategy
alwaysLowest startingBudget pot (minBet, maxBet, granularity) history = granularity

allIn :: Strategy
allIn startingBudget pot (minBet, maxBet, granularity) history = pot

martingale :: Strategy
martingale startingBudget pot (minBet, maxBet, granularity) ((lastOption, lastBet, lastWinnings, lastPot):history) = if 0 == lastWinnings then min pot (2 * lastBet) else minBet 

proportionStarting :: Strategy
proportionStarting startingBudget pot (minBet, maxBet, granularity) history = roundToNearest granularity (startingBudget * proportionOfStart)

proportionPot :: Strategy
proportionPot startingBudget pot (minBet, maxBet, granularity) history = roundToNearest granularity (pot * proportionOfPot)

-- Real stuff
runStrategy :: Option -> Strategy -> Winnings
runStrategy winningOption strategy = undefined