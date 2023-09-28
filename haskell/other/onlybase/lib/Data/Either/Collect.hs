module Data.Either.Collect where

import Data.Either

-- | Collects either all Lefts if there are any, otherwise return all Rights.
-- >>> collectEithers [Left 1, Right 2, Left 3, Right 4]
collectEithers ∷ [Either e a] → Either [e] [a]
collectEithers xs = if null . fst $ p
    then Right $ snd p
    else Left $ fst p
        where p = partitionEithers xs
