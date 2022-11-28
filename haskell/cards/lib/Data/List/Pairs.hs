module Data.List.Pairs where

import           Data.Bifoldable
import           Data.Set        as S

listToPairs ∷ [a] → [(a, a)]
listToPairs x = zip x (tail x)

pairsToList ∷ (Ord a) ⇒ [(a, a)] → [a]
pairsToList = uniq . concatMap biList
    where
        uniq ∷ Ord a ⇒ [a] → [a]
        uniq = S.toList . S.fromList

-- @TODO use \\
filterOutList ∷ (Eq a) ⇒ [a] → [a] → [a]
filterOutList bads = Prelude.filter (not . flip elem bads) -- todo reduce
