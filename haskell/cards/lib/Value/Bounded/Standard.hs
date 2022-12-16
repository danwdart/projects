{-# LANGUAGE LambdaCase      #-}
{-# LANGUAGE PatternSynonyms #-}

-- With some help from: https://www.youtube.com/watch?v=SPC_R5nwFqo

module Value.Bounded.Standard where

import           Symbol
import qualified Value.Bounded.Number as N

-- >>> map show [minBound..maxBound :: Value]
data Value = Ace | Number N.NumValue | Jack | Queen | King
    deriving stock (Eq, Ord, Show)

instance Bounded Value where
    minBound = Ace
    maxBound = King

instance Enum Value where
    toEnum = \case
        0  -> Ace
        1  -> Two
        2  -> Three
        3  -> Four
        4  -> Five
        5  -> Six
        6  -> Seven
        7  -> Eight
        8  -> Nine
        9  -> Ten
        10 -> Jack
        11 -> Queen
        12 -> King
        _  -> error "toEnum: out of bounds"

    fromEnum = \case
        Ace   -> 0
        Two   -> 1
        Three -> 2
        Four  -> 3
        Five  -> 4
        Six   -> 5
        Seven -> 6
        Eight -> 7
        Nine  -> 8
        Ten   -> 9
        Jack  -> 10
        Queen -> 11
        King  -> 12

pattern Two :: Value
pattern Two = Number N.Two

pattern Three :: Value
pattern Three = Number N.Three

pattern Four :: Value
pattern Four = Number N.Four

pattern Five :: Value
pattern Five = Number N.Five

pattern Six :: Value
pattern Six = Number N.Six

pattern Seven :: Value
pattern Seven = Number N.Seven

pattern Eight :: Value
pattern Eight = Number N.Eight

pattern Nine :: Value
pattern Nine = Number N.Nine

pattern Ten :: Value
pattern Ten = Number N.Ten

instance Symbol Value where
    symbol = \case
        Ace   -> "A"
        Two   -> "2"
        Three -> "3"
        Four  -> "4"
        Five  -> "5"
        Six   -> "6"
        Seven -> "7"
        Eight -> "8"
        Nine  -> "9"
        Ten   -> "10"
        Jack  -> "J"
        Queen -> "Q"
        King  -> "K"

{-# COMPLETE Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King #-}
