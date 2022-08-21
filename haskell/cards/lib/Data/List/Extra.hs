module Data.List.Extra where

uniq ∷ Ord a ⇒ [a] → [a]
uniq = S.toList . S.fromList

listToPairs ∷ [a] → [(a, a)]
listToPairs x = zip x (tail x)

pairsToList ∷ (Ord a) ⇒ [(a, a)] → [a]
pairsToList = uniq . concatMap biList

filterOutList ∷ (Eq a) ⇒ [a] → [a] → [a]
filterOutList bads = filter (not . flip elem bads) -- todo reduce
