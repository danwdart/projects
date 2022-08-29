module Data.List.Iterate where

-- >>> iterateUntil (== 10) succ 1
-- [1,2,3,4,5,6,7,8,9,10]
--
iterateUntil :: (a -> Bool) -> (a -> a) -> a -> [a]
iterateUntil p f x
    | p x       = [x]
    | otherwise = x : iterateUntil p f (f x)

-- >>> iterate2 (== 10) succ 1
-- [1,2,3,4,5,6,7,8,9]
--
iterateUntilJustBefore :: (a -> Bool) -> (a -> a) -> a -> [a]
iterateUntilJustBefore p f x = takeWhile (not . p) $ iterate f x

-- TODO: one more?