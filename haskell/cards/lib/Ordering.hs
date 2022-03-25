{-# LANGUAGE UnicodeSyntax #-}
module Ordering where

import           Card
import           Instances ()

newtype BySuitThenValue v s = BySuitThenValue (Card v s)
    deriving (Eq, Show)

instance (Ord v, Ord s) ⇒ Ord (BySuitThenValue v s) where
    compare (BySuitThenValue (Card val1 suit1)) (BySuitThenValue (Card val2 suit2)) =
        case compare suit1 suit2 of
            EQ -> compare val1 val2
            a  -> a

instance (Enum v, Enum s) ⇒ Enum (BySuitThenValue v s) where
    fromEnum (BySuitThenValue (Card v s)) = 13 * fromEnum s + fromEnum v
    toEnum x = BySuitThenValue (Card (toEnum valueEnum) (toEnum suitEnum))
        where (suitEnum, valueEnum) = divMod x 13

instance (Bounded v, Bounded s) ⇒ Bounded (BySuitThenValue v s) where
    minBound = BySuitThenValue minBound
    maxBound = BySuitThenValue maxBound


newtype ByValueThenSuit v s = ByValueThenSuit (Card v s)
    deriving (Eq, Show)

instance (Enum v, Enum s) ⇒ Enum (ByValueThenSuit v s) where
    fromEnum (ByValueThenSuit (Card v s)) = 4 * fromEnum v + fromEnum s
    toEnum x = ByValueThenSuit (Card (toEnum valueEnum) (toEnum suitEnum))
        where (valueEnum, suitEnum) = divMod x 4

instance (Bounded v, Bounded s) ⇒ Bounded (ByValueThenSuit v s) where
    minBound = ByValueThenSuit minBound
    maxBound = ByValueThenSuit maxBound

instance (Ord v, Ord s) ⇒ Ord (ByValueThenSuit v s) where
    compare (ByValueThenSuit (Card val1 suit1)) (ByValueThenSuit (Card val2 suit2)) =
        case compare val1 val2 of
            EQ -> compare suit1 suit2
            a  -> a
