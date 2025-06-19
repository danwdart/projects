{-# OPTIONS_GHC -Wwarn #-}

import Control.Monad.Primitive
import Control.Monad.Random.Class
import Numeric.Natural
import Data.Maybe
import Data.Vector (Vector)
import Data.Vector qualified as V
import Immutable.Shuffle
import VectorExtras.Generic

class GenericCard a where
    toCardsNext :: a -> Natural
    fromCardsNext :: Natural -> Maybe a

data GenericCardStatic = C0 | C1 | C2 | C3 | C4
    deriving stock (Eq, Show, Enum, Bounded)

instance GenericCard GenericCardStatic where
    toCardsNext = fromIntegral . fromEnum
    fromCardsNext = Just . toEnum . fromIntegral

data GenericCardDynamic = GenericCardDynamic {
    getGenericCardDynamic :: Natural
} deriving stock (Eq, Show)

instance GenericCard GenericCardDynamic where
    toCardsNext = getGenericCardDynamic
    fromCardsNext = Just . GenericCardDynamic

-- fromJust because statically known at compile time
-- maybe there's a way to imply this through TH - I don't particularly like "trust me" code
stdDeck :: GenericCard a => Vector a
stdDeck = fromJust $ traverse (fromCardsNext . fromIntegral) (V.replicate 4 =<< V.fromList [4,0,0,0,0,0,0,0,0,0,1,2,3 :: Int])

-- why the need for primitive
shuffledDeck :: (MonadRandom m, PrimMonad m, GenericCard a) => m (Vector a)
shuffledDeck = shuffleM stdDeck

startingHandsForPlayers :: (MonadRandom m, PrimMonad m, GenericCard a) => Int -> m (Vector (Vector a))
startingHandsForPlayers n = chunk n <$> shuffledDeck

data Game a = Game {
    hands :: Vector (Vector a),
    middle :: Vector a
} deriving stock (Show, Eq)

-- would be cool if we could use applicative and record AT THE SAME TIME?
-- guess that's what HKD is also for
startingGame :: (MonadRandom m, PrimMonad m, GenericCard a) => Int -> m (Game a)
startingGame players = Game <$> startingHandsForPlayers players <*> pure V.empty

-- TODO check how it works
-- move :: 

main :: IO ()
main = pure ()