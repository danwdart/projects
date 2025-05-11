{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE Unsafe            #-}
-- {-# OPTIONS_GHC -fplugin GHC.TypeLits.Normalise #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-safe -Wwarn #-}

-- Based on
module Data.DependentLength where

-- Dependent type based on length

-- import Data.Bool
import Data.Char
import Data.Foldable
import Data.Functor
import Data.Kind
-- import Data.Eq
-- import Data.Ord
-- import Data.Proxy
import Data.Type.Equality
import GHC.Err
-- import GHC.IsList
import GHC.Num
import GHC.TypeNats
import Text.Show

-- More generic monads required I think.

-- >>> :t 0 :> 1 :> 2 :> Nil
-- 0 :> 1 :> 2 :> Nil :: Num a => Vec 3 a
--

-- >>> :t 'a' :> 'b' :> 'c' :> Nil
-- 'a' :> 'b' :> 'c' :> Nil :: Vec 3 Char
--

type Vec :: Nat → Type → Type
data Vec n a where
    Nil :: Vec 0 a
    (:>) :: a -> Vec n a -> Vec (n + 1) a

type StringL a = Vec a Char

type MaxL m a = forall n. (n <= m) ⇒ Vec n a

type ML m a = forall m1 n. (n <= m1, m1 ~ m) ⇒ Vec n a

-- $> -- :set -fplugin GHC.TypeLits.Normalise

-- $> :t ('a' :> 'b' :> 'c' :> Nil) :: MaxL 3 Char

-- >>> :t ('a' :> 'b' :> 'c' :> Nil) :: MaxL 3 Char
-- (Error while loading modules for evaluation)
-- <BLANKLINE>
-- <no location info>: error:
--     Could not find module ‘GHC.TypeLits.Normalise’
-- Use -v (or `:set -v` in ghci) to see a list of the files searched for.
-- Failed, no modules loaded.
--

type MinL m a = forall n. (m <= n) ⇒ Vec n a

-- >>> :set -XAllowAmbiguousTypes
-- >>> :t 'a' :> 'b' :> Nil :: (2 <= n) => Vec n Char

-- screwy
type Password = MinL 16 Char

-- >>> :t 'a' :> 'b' :> 'c' :> Nil :: Password

-- >>> :t 'a' :> 'b' :> 'c' :> 'd' :> 'e' :> 'f' :> 'g' :> 'h' :> 'i' :> 'j' :> 'k' :> 'l' :> 'm' :> 'n' :> 'o' :> 'p' :> Nil :: Password


infixr 5 :>

deriving stock instance Show a ⇒ Show (Vec n a)

-- >>> fmap succ $ 1 :> 2 :> 3 :> Nil
-- 2 :> (3 :> (4 :> Nil))
--
deriving instance Functor (Vec n)

deriving instance Foldable (Vec n)

{-
instance IsList (Vec n a) where
    type Item (Vec n a) = a

    fromList :: [a] -> Vec n a
    fromList [] = Nil
    fromList (x:xs) = x :> fromList xs

    toList :: Vec n a -> [a]
    toList Nil = []
    toList (a :> as) = a : GHC.IsList.toList as
-}

-- >>> fromList "Hello World!" :: forall n. Vec n Char

{-}
fromList :: KnownNat n => [a] -> Vec n a -- maybe we want either existent or length passed?
fromList [] = Nil
fromList (x:xs) = x :> fromList xs
-}
-- fromNonEmpty -- this is onlybase

-- >>> toList $ 1 :> 2 :> 3 :> Nil
-- [1,2,3]
--

-- Uses foldable
{-}
and :: Vec n Bool -> Bool
and Nil = True
and (b :> bs) = b && and bs

or :: Vec n Bool -> Bool
or Nil = False
or (b :> bs) = b || or bs


-- instead implement Foldable



any :: (a -> Bool) -> Vec n a -> Bool
any _ Nil = False
any f (a :> as) = f a || any f as

all :: (a -> Bool) -> Vec n a -> Bool
all _ Nil = True
all f (a :> as) = f a && all f as
-}
-- Things in Foldable:


{-
-- these are pretty straightforward:
foldl
foldl'
foldl1
foldl1'
foldr
foldr1
scanl
scanl'
scanl1
scanr
scanr1
isPrefixOf
isSuffixOf
isInfixOf
isSubsequenceOf
-}

{-}
notElem
lookup
find

-- these are a little harder:
head
-}

head ∷ Vec n a → a
head Nil      = error "No head"
head (x :> _) = x

-- >>> head (1 :> 2 :> 3 :> Nil)
-- 1
--

-- headNE :: (1 <= n) => Vec n a -> a
-- headNE (x :> _) = x

-- >>> lastNE (1 :> 2 :> 3 :> Nil)
-- 3
--

{-}
init
-}

{-}
init :: Vec n a -> Vec (n - 1) a
init Nil = error "Wat"
init (_ :> Nil) = Nil
init (a :> _ :> Nil) = a :> Nil
init (a :> as) = a :> init as
-}

-- >>> headNE (1 :> 2 :> 3 :> Nil)
-- 1
--

-- last ∷ Vec n a → a
-- last Nil        = error "No last"
-- last (x :> Nil) = x
-- last (_ :> xs)  = head (reverse xs)

-- >>> last (1 :> 2 :> 3 :> Nil)
-- 3
--

-- lastNE :: (1 <= n) => Vec n a -> a
-- lastNE (x :> Nil) = x
-- lastNE (_ :> xs) = last xs

{-}
last
uncons
singleton
-}

-- >>> map succ $ 1 :> 2 :> 3 :> Nil
-- 2 :> (3 :> (4 :> Nil))
--
map ∷ (a → b) → Vec n a → Vec n b
map _ Nil       = Nil
map f (x :> xs) = f x :> fmap f xs

{-
zip :: Vec n a -> Vec m b -> Vec n (a, b)
zip Nil _ = Nil
zip _ Nil = Nil
zip (a :> as) (b :> bs) = (a, b) :> zip as bs
-}

-- unzip :: Vec n (a, b) -> (Vec n a, Vec n b)
-- unzip Nil = error "Aaaah!"
-- unzip ((a, b) :> asbs) = undefined

{-}
zipWith :: (a -> b -> c) -> Vec n a -> Vec n b -> Vec n c
zipWith _ Nil _ = Nil
zipWith _ _ Nil = Nil
zipWith f (a :> as) (b :> bs) = f a b :> zipWith f as bs
-}

{-}
zip
unzip
zipWith
-}

-- >>> snoc (1 :> 2 :> 3 :> Nil) 4
-- 1 :> (2 :> (3 :> (4 :> Nil)))
--
snoc ∷ Vec n a → a → Vec (n + 1) a
snoc Nil x       = x :> Nil
snoc (y :> ys) x = y :> (ys `snoc` x)

-- >>> reverseOld $ 1 :> 2 :> 3 :> Nil
-- 3 :> (2 :> (1 :> Nil))
--
reverseOld ∷ Vec n a → Vec n a
reverseOld Nil       = Nil
reverseOld (x :> xs) = reverseOld xs `snoc` x

{-}
reverse :: Vec n a -> Vec n a
reverse = go Nil ys
    where
        go :: Vec m a -> Vec p a -> Vec (m + p) a
        go acc Nil = acc
        go acc (x :> xs) = go (x :> acc) xs
-}

{-
mapAccumL
mapAccumR
insert
sort
null
-}

-- BEGIN Foldable

{-}

toList :: Vec n a -> [a]
toList Nil = []
toList (a :> as) = a : toList as


-- >>> lengthCalc (1 :> 2 :> 3 :> Nil)
-- 3
--
lengthCalc :: Vec n a -> Nat
lengthCalc Nil = 0
lengthCalc (_ :> xs) = 1 + lengthCalc xs

-- >>> length (1 :> 2 :> 3 :> Nil)
-- 3
--
length :: forall n a. KnownNat n => Vec n a -> Nat
length _ = natVal (Proxy :: Proxy n)

elem :: Eq a => a -> Vec n a -> Bool
elem _ Nil = False
elem x (y :> ys) = x == y || elem x ys

maximum :: (Ord a) => Vec n a -> a
maximum Nil = error "You shouldn't be here."
maximum (a :> Nil) = a
maximum (a :> as) = max a (maximum as)

minimum :: (Ord a) => Vec n a -> a
minimum Nil = error "You shouldn't be here."
minimum (a :> Nil) = a
minimum (a :> as) = min a (minimum

-- >>> sumNaive $ 1 :> 2 :> 3 :> 4 :> Nil
-- 10
--
sumNaive :: (Num a) => Vec n a -> a
sumNaive Nil = 0
sumNaive (a :> as) = a + sum as

-- >>> sum $ 1 :> 2 :> 3 :> 4 :> Nil
-- 10
--
sum :: (Num a) => Vec n a -> a
sum = go 0
    where
        go :: (Num a) => a -> Vec n a -> a
        go acc Nil = acc
        go acc (a :> as') = go (acc + a) as'

-- >>> productNaive $ 1 :> 2 :> 3 :> 4 :> Nil
-- 24
--
productNaive :: (Num a) => Vec n a -> a
productNaive Nil = 1
productNaive (a :> as) = a * product as

-- >>> product $ 1 :> 2 :> 3 :> 4 :> Nil
-- 24
--
product :: (Num a) => Vec n a -> a
product = go 1
    where
        go :: (Num a) => a -> Vec n a -> a
        go acc Nil = acc
        go acc (a :> as') = go (acc * a) as'
-}
-- END Foldable


-- replicate :: Natural -> a -> Vec n a
-- replicate 0 _ = Nil
-- replicate n x = x :> replicate (n - 1) x

-- (++) :: Vec n a -> Vec m a -> Vec (n + m) a
-- Nil ++ v = v
-- (x :> xs) ++ v = x :> (xs ++ v)

-- take :: n' -> Vec n a -> Vec (min n' n) a
-- take 0 _ = Nil
-- take _ Nil = Nil
-- take n' (x :> xs) = x :> take (n' - 1) xs

{-}
drop
stripPrefix
splitAt
concat
-- these need fancy type families (quite hard):
intersperse
inits
tails
intercalate
subsequences
permutations
transpose
-- these need existentials:
concatMap
unfoldr
takeWhile
dropWhile
dropWhileEnd
-}

-- wants existential?
-- filter :: (m <= n) => (a -> Bool) -> Vec n a -> Vec m a
-- filter _ Nil = Nil
-- filter p (x :> xs) | p x = x :> filter p xs
--                    | otherwise = filter p xs


{-}
nub
delete
(\\)
-}

{-}
union :: (n <= nm, m <= nm) => Vec n a -> Vec m a -> Vec nm a
union xs Nil = xs
union Nil ys = ys
union (x :> xs) ys | x `elem` ys = union xs ys
                   | otherwise = x :> union xs ys
-}

{-}
intersect
-- these need Fin:
-}


(!!) ∷ Vec n a → Nat → a -- Get the nat
Nil !! _       = error "Nah"
(x :> _) !! 0  = x
(_ :> xs) !! n = head xs

-- >>> 1 :> 2 :> Nil !!! 1
-- <interactive>:32039:16-18: error:
--     • Cannot satisfy: 1 <= 0
--     • In the second argument of ‘(:>)’, namely ‘Nil !!! 1’
--       In the second argument of ‘(:>)’, namely ‘2 :> Nil !!! 1’
--       In the expression: 1 :> 2 :> Nil !!! 1
--

-- >>> 1 :> 2 :> Nil !!! 2
-- <interactive>:31933:16-18: error:
--     • Cannot satisfy: 1 <= 0
--     • In the second argument of ‘(:>)’, namely ‘Nil !!! 2’
--       In the second argument of ‘(:>)’, namely ‘2 :> Nil !!! 2’
--       In the expression: 1 :> 2 :> Nil !!! 2
--
-- (!!!) :: (1 <= n) => Vec n a -> Nat -> a -- get that Nat
-- (x :> _) !!! 0 = x
-- (_ :> xs) !!! n = xs !! (n - 1)

{-}
elemIndex
elemIndices
findIndex
findIndices
-- these need custom GADTs to encode the right conditions:
-}

{-}
span :: (a -> Bool) -> Vec (m + n) a -> (Vec m a, Vec n a)
span p Nil = (Nil, Nil)
span p (x :> xs) = _
-}

{-}
break
partition
group
-}

{-
The functions listed here we will not attempt.
-- these are not illuminating:
zip3
zip4
zip5
zip6
zip7
zipWith3
zipWith4
zipWith5
zipWith6
zipWith7
unzip3
unzip4
unzip5
unzip6
unzip7
-- these are really about text, not about lists:
lines
words
unlines
unwords
-- these are straightforward generalizations:
nubBy
deleteBy
deleteFirstsBy
unionBy
intersectBy
groupBy
sortBy
insertBy
maximumBy
minimumBy
genericLength
genericTake
genericDrop
genericSplitAt
genericIndex
genericReplicate
sortOn
-- no infinite vectors:
no iterate
no iterate'
no repeat
no cycle
-}
