{-# OPTIONS_GHC -Wno-unused-matches -Wno-all-missed-specialisations #-}
-- where do I put {-# INLINABLE Element #-}
{-# LANGUAGE DeriveFunctor       #-}
{-# LANGUAGE OverloadedLists     #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Data.ListIndex where

{- ANN module "HLint: ignore Avoid restricted function" -}

-- Should probably be something for "sequential" things.

data Element ix a = Enum ix => Element {
    ix  :: ix,
    get :: a
}

deriving instance (Show ix, Show a) ⇒ Show (Element ix a)
deriving instance Functor (Element ix)

data ListIndex ix a = Nil | Element ix a :> ListIndex ix a
    deriving stock (Show, Functor)

infixr 5 :>

-- what is the group type of things with a null element

-- >>> fmap succ $ fromList [0, 0, 7]
-- Element {ix = 0, get = 1} :> (Element {ix = 1, get = 1} :> (Element {ix = 2, get = 8} :> Nil))
--

-- >>> fromList [1,2,3]
-- Element {ix = 0, get = 1} :> (Element {ix = 1, get = 2} :> (Element {ix = 2, get = 3} :> Nil))
--
-- >>> fromList [1]
-- Element {ix = 0, get = 1} :> Nil
--

-- >>> fromList []
-- Nil
--
fromList ∷ (Num ix, Enum ix) ⇒ [a] → ListIndex ix a
fromList xs = go xs 0 where
    go ∷ (Num ix, Enum ix) ⇒ [a] → ix → ListIndex ix a
    go [] _          = Nil
    go [x] start     = Element start x :> Nil
    go (x:xs') start = Element start x :> go xs' (succ start)

toList ∷ ListIndex ix a → [a]
toList = undefined

-- fromSequentialMap
-- toSequentialMap
-- O(n), probably. Ugh.
getElement ∷ ix → ListIndex ix a → Maybe a
getElement ix lixa = undefined

-- constructors should be internal only to prevent screwing up

-- >>> sampleList
-- Element {ix = 0, get = 0} :> (Element {ix = 1, get = 1} :> (Element {ix = 2, get = 2} :> Nil))
--
sampleList ∷ ListIndex Int Int
sampleList = Element 0 0 :> Element 1 1 :> Element 2 2 :> Nil

-- Functor able to reference whole thing too?

-- >>> wmap (\x l -> l ++ [x]) [1,2,3]
-- [[1,2,3,1],[1,2,3,2],[1,2,3,3]]
--
class WholeFunc f where
    wmap :: (a → f a → b) → f a → f b

instance WholeFunc [] where
    wmap :: forall a b. (a → [a] → b) → [a] → [b]
    wmap _ [] = []
    wmap f xs = go f xs where
        go ∷ (a → [a] → b) → [a] → [b]
        go _ []       = []
        go f' (x:xs') = f' x xs : go f' xs'

-- Functor able to reference index too

class IndexedFunctor f ix where
    imap :: (a → ix → b) → f ix a → f ix b

{-}
-}

-- >>> limap (+) [0, 0, 0]
-- [0,1,2]
--

limap ∷ (Enum ix, Num ix) ⇒ (a → ix → b) → [a] → [b]
limap _ [] = []
limap f xs = go f xs 0 where
    go ∷ (Enum ix, Num ix) ⇒ (a → ix → b) → [a] → ix → [b]
    go _ [] _           = []
    go f' (x:xs') start = f' x start : go f' xs' (succ start)

class WholeIndexedFunctor f ix where
    wimap :: (a → ix → f a → b) → f a → f b

-- instance Num ix => WholeIndexedFunctor [] ix where

-- >>> lwimap (\x ix l -> l ++ [x + ix]) [0, 0, 0]
-- [[0,0,0,0],[0,0,0,1],[0,0,0,2]]
--

-- very like JS forEach()

lwimap ∷ forall a b ix. (Enum ix, Num ix) ⇒ (a → ix → [a] → b) → [a] → [b]
lwimap f xs = go f xs 0 where
    -- no type sig or make sure we match them w/ext
    go ∷ (a → ix → [a] → b) → [a] → ix → [b]
    go _ [] _           = []
    go f' (x:xs') start = f' x start xs : go f' xs' (succ start)

-- integrate the above?

