{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import           Data.List.Extra
import           Deck
import           Ordering
import           Relude.Extra.Bifunctor
import           Suit.Bounded.Standard  as SuitStandard
import           Value.Bounded.Standard as ValueStandard

cards ∷ DeckStd
cards = Deck $ getBySuitThenValue <$> enumerate @(BySuitThenValue ValueStandard.Value SuitStandard.Suit)

cutDeck ∷ Int → DeckStd → (DeckStd, DeckStd)
cutDeck x = bimapBoth Deck . splitAt x . getDeck

interlaceDeck ∷ DeckStd → DeckStd → DeckStd
interlaceDeck d1 d2 = Deck . concat . transpose $ [getDeck d1, getDeck d2]

farrowShuffleOut ∷ DeckStd → DeckStd
farrowShuffleOut = uncurry interlaceDeck . cutDeck 26

farrowShuffleIn ∷ DeckStd → DeckStd
farrowShuffleIn = uncurry (flip interlaceDeck) . cutDeck 26

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
main = do
    putStrLn $ "Out: " <> show (calculateWith farrowShuffleOut)
    putStrLn $ "In: " <> show (calculateWith farrowShuffleIn)

    putStrLn $ "In Out: " <> show (calculateWith (farrowShuffleOut . farrowShuffleIn))
    putStrLn $ "Out In: " <> show (calculateWith (farrowShuffleIn . farrowShuffleOut))

    putStrLn $ "In Out In: " <> show (calculateWith (farrowShuffleIn . farrowShuffleOut . farrowShuffleIn))
    putStrLn $ "In Out Out: " <> show (calculateWith (farrowShuffleOut . farrowShuffleOut . farrowShuffleIn))

    putStrLn $ "Out In In: " <> show (calculateWith (farrowShuffleIn . farrowShuffleIn . farrowShuffleOut))
    putStrLn $ "Out In Out: " <> show (calculateWith (farrowShuffleOut . farrowShuffleIn . farrowShuffleOut))

    putStrLn $ "In Out Out In: " <> show (calculateWith (farrowShuffleIn . farrowShuffleOut . farrowShuffleOut . farrowShuffleIn))
    putStrLn $ "In In Out In: " <> show (calculateWith (farrowShuffleIn . farrowShuffleOut . farrowShuffleIn . farrowShuffleIn))

    putStrLn $ "Out Out Out Out In: " <> show (calculateWith (farrowShuffleIn . farrowShuffleOut . farrowShuffleOut . farrowShuffleOut . farrowShuffleOut))
