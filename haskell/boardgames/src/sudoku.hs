{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-unused-imports #-}

import           Algebra.Lattice
import           Data.List.Extra (enumerate)
import           Data.Set        (Set)
import qualified Data.Set        as S
import           Data.Vector     (Vector)
import qualified Data.Vector     as V

-- | The individual cell value.
data Choice = One | Two | Three | Four | Five | Six | Seven | Eight | Nine
    deriving stock (Eq, Show, Ord, Enum, Bounded)

-- We should be using the bounded join semilattice for Set Choice
-- so its bottom would be "contradiction" which is nothing in the set
-- and its top would be "no information" which is everything in the set
-- then "meet" would be set difference and "join" would be union? Something like that?

-- Now we can run the algorithm of all the things to check... at once, as a fixpoint?
solveFour ∷ Vector (Vector Choice) → Vector (Vector Choice)
solveFour = undefined

-- | Show the choice as a string.
-- >>> concat $ prettyShow <$> enumerate
-- "123456789"
--
prettyShow ∷ Choice → String
prettyShow = show . succ . fromEnum

main ∷ IO ()
main = pure ()
