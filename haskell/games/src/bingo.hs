{-# LANGUAGE DeriveAnyClass, DerivingStrategies, OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-unused-packages -Wno-partial-fields -Wno-unused-matches #-}

-- import Control.Exception
import Control.Exception.RangeException
import Control.Monad.Random
-- import Data.Kind
-- import Faker
import Faker.Class
-- import Faker.Name
import Numeric.Natural
-- import Data.Text qualified as T
import Data.Text (Text)
import Data.Text.Display
import Data.Text.Lazy.Builder qualified as TB
import Data.Vector (Vector)
import Data.Vector qualified as V
import Numeric.Range

main :: IO ()
main = pure ()

-- TODO distribute possibilities from a given pile
-- probably best is https://hackage.haskell.org/package/lens-4.5/docs/Control-Lens-Cons.html

-- | Classes

data Game cardType possibilityType = Game {
    balls :: Vector possibilityType,
    discard :: Vector possibilityType,
    players :: Vector (cardType possibilityType)
}

mkPlayer :: {-(MonadFake m, MonadRandom m, Card cardType possibilityType, Possibility possibilityType) => -} m (Player cardType possibilityType)
mkPlayer = undefined

mkGame :: (MonadFake m, MonadRandom m {- }, Card cardType possibilityType, Possibility possibilityType -}) => m (Game cardType possibilityType)
mkGame = do
    numPlayers <- getRandom :: MonadRandom m => m Int -- TODO Natural
    let balls = undefined -- V.fromList $ makeNumber <$> [1..75]
    let discard = V.fromList []
    players <- undefined -- _ . V.fromList <$> replicateM numPlayers mkPlayer -- TODO sequenceA
    pure $ Game balls discard players


-- Better Bool!
data MarkStatus = Unmarked | Marked deriving stock (Eq, Show, Ord, Enum)

data NumberWithMarkStatus a = NumberWithMarkStatus {
    _getNumber :: a,
    _markStatus :: MarkStatus
}

-- TODO do we even need functor
-- TODO lenses
mark :: NumberWithMarkStatus a -> NumberWithMarkStatus a
mark nw = nw { _markStatus = Marked }


-- type Possibility :: Type -> Constraint
class Possibility p where
    mkRandomPossibility :: MonadRandom m => m p

instance Possibility p => Possibility (NumberWithMarkStatus p) where
    mkRandomPossibility :: MonadRandom m => m (NumberWithMarkStatus p)
    mkRandomPossibility = mkRandomPossibility >>= \n -> pure NumberWithMarkStatus {
        _getNumber = n,
        _markStatus = Unmarked
    }

-- type Card :: Type -> Constraint
class Possibility p => Card c p where
    mkRandomCard :: (MonadRandom m) => m (c p)

data Player card possibility = Player {
    name :: Text,
    card :: card possibility
}

-- | Static Possibilities
data ColStatic = ColB | ColI | ColN | ColG | ColO deriving stock (Eq, Show, Ord, Enum)

-- TODO FixedInt 15
data OffsetStatic = SO0 | SO1 | SO2 | SO3 | SO4 | SO5 | SO6 | SO7 | SO8 | SO9 | SO10 | SO11 | SO12 | SO13 | SO14 deriving stock (Eq, Show, Ord, Enum)

data NumberStatic = NumberStatic {
    staticCol :: ColStatic,
    staticOffset :: OffsetStatic
}

instance Display NumberStatic where
    displayBuilder _ = TB.fromText "TODO"

instance Possibility NumberStatic where
    mkRandomPossibility :: m NumberStatic
    mkRandomPossibility = undefined

-- | Dynamic Possibilities

-- don't use this constructor (TODO export smart constructor from an external module)
newtype NumberDynamic = NumberDynamic Natural deriving stock (Eq, Show, Ord) deriving newtype (Enum)

instance Bounded NumberDynamic where
    minBound = NumberDynamic 1
    maxBound = NumberDynamic 75

instance Possibility NumberDynamic where
    mkRandomPossibility :: m NumberDynamic
    mkRandomPossibility = undefined

-- smart constructor
mkNumberDynamic :: Natural -> Either (RangeException Natural) NumberDynamic
mkNumberDynamic = mkWithRange NumberDynamic 1 75

-- Stolen from Data.List.Extra
enumerate :: (Bounded a, Enum a) => [a]
enumerate = [minBound..maxBound]

allNumbers :: [NumberDynamic]
allNumbers = enumerate

-- | Dynamic Cards

data ColDynamic a = RowDynamicFull {
    choices :: [a]
} | RowDynamicSplit {
    choicesLeft :: [a],
    choicesRight :: [a]
}

newtype CardDynamic a = CardDynamic [ColDynamic a]

instance (Possibility p) => Card CardDynamic p where
    mkRandomCard :: m (CardDynamic p)
    mkRandomCard = undefined

-- | Static Cards
data Col4 a = Col4 {
    b4 :: a,
    i4 :: a,
    -- this is where free would go
    g4 :: a,
    o4 :: a
}

data Col5 a = Col5 {
    b5 :: a,
    i5 :: a,
    n5 :: a,
    g5 :: a,
    o5 :: a
}

data CardStatic a = CardStatic {
    r1 :: Col5 a,
    r2 :: Col5 a,
    r3 :: Col4 a,
    r4 :: Col5 a,
    r5 :: Col5 a
}

-- TODO: mark the cards? Use MarkableNumber n: UnmarkedNumber n | MarkedNumber n to replace the number with.

instance Possibility p => Card CardStatic p where
    mkRandomCard :: m (CardStatic p)
    mkRandomCard = undefined

-- | Generate an unmarked card.

-- | Generate a player.

-- | Generate a room of players.

-- | Draw a number.

-- | Mark a card with a number.

-- | Check if a player has won.

-- | Run a game to completion.