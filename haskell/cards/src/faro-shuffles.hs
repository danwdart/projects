{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Data.Bifunctor
import Data.List.Extra
import Deck
import Ordering
import Suit.Bounded.Standard  as SuitStandard
import Value.Bounded.Standard as ValueStandard

-- Relude's makes us need earlier versions of stuff
bimapBoth ∷ Bifunctor p ⇒ (a → b) → p a a → p b b
bimapBoth f = bimap f f

cards ∷ DeckStd
cards = Deck $ getBySuitThenValue <$> enumerate @(BySuitThenValue ValueStandard.Value SuitStandard.Suit)

cutDeck ∷ Int → DeckStd → (DeckStd, DeckStd)
cutDeck x = bimapBoth Deck . splitAt x . getDeck

interlaceDeck ∷ DeckStd → DeckStd → DeckStd
interlaceDeck d1 d2 = Deck . concat . transpose $ [getDeck d1, getDeck d2]

faroShuffleOut ∷ DeckStd → DeckStd
faroShuffleOut = uncurry interlaceDeck . cutDeck 26

faroShuffleIn ∷ DeckStd → DeckStd
faroShuffleIn = uncurry (flip interlaceDeck) . cutDeck 26

untilTimes ∷ forall a. Int → (a → Bool) → (a → a) → a → Maybe Int
untilTimes maxTimes check iterator = go 0 where
    go ∷ Int → a → Maybe Int
    go iterNum element
        | check element = Just iterNum
        | maxTimes <= iterNum = Nothing
        | otherwise = go (iterNum + 1) (iterator element)

untilTimesAtLeastOne ∷ forall a. Int → (a → Bool) → (a → a) → a → Maybe Int
untilTimesAtLeastOne maxTimes check iterator = go 0 where
    go ∷ Int → a → Maybe Int
    go iterNum element
        | iterNum > 0 && check element = Just iterNum
        | maxTimes <= iterNum = Nothing
        | otherwise = go (iterNum + 1) (iterator element)

calculateWith ∷ (DeckStd → DeckStd) → Maybe Int
calculateWith fn = untilTimesAtLeastOne 100000 (== cards) fn cards

main ∷ IO ()
main = mapM_ (\(name, calculation) -> putStrLn $ name <> ": " <> show (calculateWith calculation)) [
    ("Out", faroShuffleOut),
    ("In", faroShuffleIn),
    ("In Out", faroShuffleOut . faroShuffleIn),
    ("Out In", faroShuffleIn . faroShuffleOut),
    ("In Out In", faroShuffleIn . faroShuffleOut . faroShuffleIn),
    ("In Out Out", faroShuffleOut . faroShuffleOut . faroShuffleIn),
    ("Out In In", faroShuffleIn . faroShuffleIn . faroShuffleOut),
    ("Out In Out", faroShuffleOut . faroShuffleIn . faroShuffleOut),
    ("In Out Out In", faroShuffleIn . faroShuffleOut . faroShuffleOut . faroShuffleIn),
    ("In In Out In", faroShuffleIn . faroShuffleOut . faroShuffleIn . faroShuffleIn),
    ("Out Out Out Out In", faroShuffleIn . faroShuffleOut . faroShuffleOut . faroShuffleOut . faroShuffleOut)
    ]
