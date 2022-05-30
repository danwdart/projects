-- | WeakSet: Unordered Set
module Data.Set.Ordered where

import GHC.Exts

-- | Implicitly ordered set.

-- As long as this isn't a newtype it shouldn't be easy to coerce into.
data Set a = Nil | a :> Set a
    deriving (Eq, Ord, Show)

infixr 5 :>

instance Eq a => Semigroup (Set a) where
    (<>) = union

instance Eq a => Monoid (Set a) where
    mempty = empty
    mappend = (<>)

--instance IsList (Set a) where
--    fromList = _
--    toList = _

-- >>> empty
-- Nil
--
empty :: Set a
empty = Nil

-- >>> singleton 1
-- 1 :> Nil
--
singleton :: a -> Set a
singleton a = a :> Nil

-- >>> union (1 :> 2 :> 3 :> Nil) (4 :> 5 :> 6 :> Nil)
-- 1 :> (2 :> (3 :> (4 :> (5 :> (6 :> Nil)))))

-- >>> union (1 :> 2 :> 3 :> Nil) (1 :> 2 :> 3 :> Nil)
-- 1 :> (2 :> (3 :> Nil))

-- >>> union Nil Nil
-- Nil
--

union :: Eq a => Set a -> Set a -> Set a
union a Nil = a
union Nil a = a
union (x :> xs) ys
        | (x `Data.Set.Ordered.elem` ys) = union xs ys
        | otherwise = x :> union xs ys

-- insert :: Ord a => a -> Set a -> Set a
-- insert a Nil = a :> Nil
-- insert a (x :> xs)
--     | x `Data.Set.Ordered.elem` xs = x :> xs

-- >>> delete 1 (1 :> 2 :> 3 :> Nil)
-- 2 :> (3 :> Nil)
--
-- >>> delete 4 (1 :> 2 :> 3 :> Nil)
-- 1 :> (2 :> (3 :> Nil))
--
delete :: Eq a => a -> Set a -> Set a
delete _ Nil = Nil
delete a (x :> xs)
    | a == x = xs
    | otherwise = x :> delete a xs

-- >>> 1 `Data.Set.Ordered.elem` Nil
-- False
--

-- >>> 1 `Data.Set.Ordered.elem` (1 :> 2 :> 3 :> Nil)
-- True
--

-- >>> 4 `Data.Set.Ordered.elem` (1 :> 2 :> 3 :> Nil)
-- False
--

elem :: Eq a => a -> Set a -> Bool
elem _ Nil = False
elem a (x :> xs)
    | a == x = True
    | otherwise = Data.Set.Ordered.elem a xs

includes :: Eq a => Set a -> a -> Bool
includes = flip Data.Set.Ordered.elem

-- fromList :: [a] -> Set a
-- fromList [] = Nil
-- fromList (x : xs) = x :> Data.Set.Ordered.fromList xs

-- toList :: Set a -> [a]
-- toList Nil = []
-- toList (x :> xs) = x : Data.Set.Ordered.toList xs

-- >>> size $ 1 :> 2 :> 3 :> Nil
-- 3
--
size :: Set a -> Int
size Nil = 0
size (_ :> xs) = size xs + 1

-- Just makes a new Set. No guarantee that the length is the same.
map :: (a -> b) -> Set a -> Set b
map = undefined