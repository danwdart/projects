
module Deck where

import           Card

newtype Deck a = Deck {
    getDeck :: [a]
} deriving (Eq, Functor, Show)

type DeckStd = Deck CardStd
type DeckJill = Deck CardJill
type DeckUnbounded = Deck CardUnbounded
