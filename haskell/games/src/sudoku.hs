{-# LANGUAGE DefaultSignatures #-}
{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-unused-imports #-}

module Main (main) where

import Data.List.Extra (enumerate)
import Data.Set        (Set)
-- import Data.Set        qualified as S
import Data.Vector     (Vector)
import Data.Vector     qualified as V
import Propagator

-- | The individual cell value.

-- | Show the choice as a string.
class PrettyShow a where
    prettyShow :: a → String
    default prettyShow :: (Enum a) ⇒ a → String
    prettyShow = show . succ . fromEnum

data Choice4 = C4One | C4Two | C4Three | C4Four
    deriving stock (Eq, Show, Ord, Enum, Bounded)

instance PrettyShow Choice4

data Choice9 = C9One | C9Two | C9Three | C9Four | C9Five | C9Six | C9Seven | C9Eight | C9Nine
    deriving stock (Eq, Show, Ord, Enum, Bounded)

instance PrettyShow Choice9

-- One|Three Two|Four
-- SET A1 to Four is equivalent to Others = Others /\ Four?

-- For each cell, for those related, do the \/
newtype Board = Board (Vector (Vector (Cell (Set Choice9))))

mkBoard ∷ IO Board
mkBoard = Board <$> V.replicateM 9 (V.replicateM 9 cell)

main ∷ IO ()
main = pure ()
