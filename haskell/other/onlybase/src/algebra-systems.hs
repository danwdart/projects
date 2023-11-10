module Main (main) where

by ∷ (Show t1, Show t2, Show a) ⇒ (t2 → t1 → a) → t1 → t2 → String
by f n m = show n <> (" with " <> (show m <> (" = " <> show (f m n))))

dor ∷ (a → a → b) → [a] → [[b]]
dor f r = fmap (flip (fmap . f) r) r

resulter ∷ [Integer] → [[String]]
resulter = dor $ by max

result ∷ [[String]]
result = resulter [0..10]

main ∷ IO ()
main = print result
