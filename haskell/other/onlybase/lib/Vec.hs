-- https://www.youtube.com/watch?v=PHS3Q-tRjFQ
{-# LANGUAGE ConstraintKinds              #-}
{-# LANGUAGE DataKinds                    #-}
{-# LANGUAGE DerivingStrategies           #-}
{-# LANGUAGE FlexibleInstances            #-}
{-# LANGUAGE GADTs                        #-}
{-# LANGUAGE MultiParamTypeClasses        #-}
{-# LANGUAGE NoGeneralisedNewtypeDeriving #-}
{-# LANGUAGE Safe                         #-}
{-# LANGUAGE ScopedTypeVariables          #-}
{-# LANGUAGE StandaloneDeriving           #-}
{-# LANGUAGE StandaloneKindSignatures     #-}
{-# LANGUAGE TypeOperators                #-}
{-# OPTIONS_GHC -Weverything -Werror #-}
{-# OPTIONS_GHC -Wno-missing-import-lists #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}
{-# LANGUAGE IncoherentInstances          #-}
{-# LANGUAGE TypeFamilies                 #-}
{-# LANGUAGE UndecidableSuperClasses      #-}

-- | Length Index-Vector
module Vec (Vec(..), and, head, init, map, length) where

import safe Data.Kind (Constraint, Type)
import Prelude   hiding (and, elem, filter, head, init, length, map, replicate,
                  tail, take, (++))

type Nat :: Type
data Nat = Zero | Succ Nat
    deriving stock Show

type Vec :: Nat → Type → Type
data Vec n a where
    Nil :: Vec 'Zero a
    (:>) :: a -> Vec n a -> Vec ('Succ n) a
infixr 5 :>

-- >>> fmap succ (1 :> 2 :> 3 :> Nil)
-- 2 :> (3 :> (4 :> Nil))
--

deriving stock instance Functor (Vec n)

-- >>> 1 :> Nil
-- 1 :> Nil
--
-- >>> :t 'a' :> 'b' :> Nil
-- 'a' :> 'b' :> Nil :: Vec ('Succ ('Succ 'Zero)) Char
deriving stock instance Show a ⇒ Show (Vec n a)

-- >>> SSucc SZero
-- No instance for (Show (SNat ('Succ 'Zero)))
--   arising from a use of `evalPrint'
-- In a stmt of an interactive GHCi command: evalPrint it_a18Ub
type SNat :: Nat → Type
data SNat n where
    SZero :: SNat 'Zero
    SSucc :: SNat n -> SNat ('Succ n)

type (+) :: Nat → Nat → Nat
type family a + b where
    'Zero + b = b
    'Succ a + b = 'Succ (a + b)

-- >>> (1 :> 2 :> Nil) ++ (3 :> 4 :> Nil)
-- 1 :> (2 :> (3 :> (4 :> Nil)))
(++) ∷ Vec n a → Vec m a → Vec (n + m) a
Nil ++ v       = v
(x :> xs) ++ v = x :> (xs <> v)

-- >>> and $ True :> False :> Nil
-- False
--
-- >>> and $ True :> Nil
-- True
--
and ∷ Vec n Bool → Bool
and Nil       = True
and (a :> as) = a && and as

-- >>> head $ 1 :> 2 :> Nil
-- 1
--
-- >>> head $ Nil
-- <interactive>:9550:9-11: error:
--     • Couldn't match type ‘'Zero’ with ‘'Succ n0’
--       Expected: Vec ('Succ n0) a
--         Actual: Vec 'Zero a
--     • In the second argument of ‘($)’, namely ‘Nil’
--       In the expression: head $ Nil
--       In an equation for ‘it’: it = head $ Nil
--
head ∷ Vec ('Succ n) a → a
head (x :> _) = x

-- >>> init $ 1 :> 2 :> Nil
-- 1 :> Nil
--
-- >>> init $ Nil
-- Couldn't match type 'Zero with 'Succ n_a24A9[sk:1]
-- Expected: Vec ('Succ n_a24A9[sk:1]) a_a24Aa[sk:1]
--   Actual: Vec 'Zero a_a24Aa[sk:1]
-- In the second argument of `($)', namely `Nil'
-- In the expression: init $ Nil
-- In an equation for `it_a24z3': it_a24z3 = init $ Nil
-- Relevant bindings include
--   it_a24z3 :: Vec n_a24A9[sk:1] a_a24Aa[sk:1]
--     (bound at /home/dwd/code/mine/multi/projects/haskell/other/onlybase/lib/Vec.hs:87:2)
init ∷ Vec ('Succ n) a → Vec n a
init (_ :> Nil)         = Nil
init (x :> xs@(_ :> _)) = x :> init xs

{-# ANN function "HLint: ignore Use fmap" #-}

-- >>> map succ $ 1 :> 2 :> Nil
-- 2 :> (3 :> Nil)
--
map ∷ (a → b) → Vec n a → Vec n b
map _ Nil       = Nil
map f (x :> xs) = f x :> fmap f xs

-- Nat not dependent, breakable.
-- >>> length $ 1 :> 2 :> Nil
-- Succ (Succ Zero)
--
length ∷ forall n a. Vec n a → Nat
length Nil       = Zero
length (_ :> xs) = Succ (length xs)

-- >>> wrongLength $ 1 :> 2 :> Nil
-- Zero
--
wrongLength ∷ forall n a. Vec n a → Nat
wrongLength Nil      = Zero
wrongLength (_ :> _) = Zero

-- Nat dependent
-- >>> lengthS $ 1 :> 2 :> Nil
-- <interactive>:10876:2-24: error:
--     • No instance for (Show (SNat ('Succ ('Succ 'Zero))))
--         arising from a use of ‘print’
--     • In a stmt of an interactive GHCi command: print it
--
lengthS ∷ Vec n a → SNat n
lengthS Nil       = SZero
lengthS (_ :> xs) = SSucc (lengthS xs)

{-
Couldn't match type ‘'Zero’ with ‘'Succ n1’
  Expected: SNat n
    Actual: SNat 'Zero
-}
{-
wrongLengthS :: Vec n a -> SNat n
wrongLengthS Nil = SZero
wrongLengthS (_ :> _) = SZero
-}

-- >>> replicate (SSucc (SSucc SZero)) 1
-- 1 :> (1 :> Nil)
--
replicate ∷ SNat n → a → Vec n a
replicate SZero _     = Nil
replicate (SSucc n) x = x :> replicate n x

{-
Couldn't match type ‘n’ with ‘'Zero’
  Expected: Vec n a
    Actual: Vec 'Zero a
-}

{-
replicateNotS :: forall (n :: Nat). Nat -> a -> Vec n a
replicateNotS Zero _ = Nil
replicateNotS (Succ n) x = x :> replicateNotS n x
-}

type Min :: Nat → Nat → Nat
type family Min a b where
    Min 'Zero _ = 'Zero
    Min ('Succ _) 'Zero = 'Zero
    Min ('Succ n) ('Succ m) = 'Succ (Min n m)

-- >>> take (SSucc (SSucc (SSucc SZero))) (1 :> 2 :> 3 :> 4 :> 5 :> Nil)
-- 1 :> (2 :> (3 :> Nil))
--
take ∷ SNat n → Vec m a → Vec (Min n m) a
take SZero _              = Nil
take (SSucc _) Nil        = Nil
take (SSucc n') (x :> xs) = x :> take n' xs

type EVec :: (Nat → Constraint) → Type → Type
data EVec c a where
    MkEVec :: c n => Vec n a -> EVec c a

type KnowNothing :: Nat → Constraint
class KnowNothing n
instance KnowNothing n

type (>=) :: Nat → Nat → Constraint
class m >= n
instance m >= 'Zero
-- instance (m >= n) => ('Succ m >= 'Succ n)
-- instance {-# OVERLAPPABLE #-} (m >= n) => ('Succ m >= n)

-- >>> filter (>2) 1 :> 2 :> 3 :> 4 :> Nil
-- <interactive>:16871:2-36: error:
--     • No instance for (Show (EVec ((>=) n0) Integer))
--         arising from a use of ‘print’
--     • In a stmt of an interactive GHCi command: print it
--

{-
filter :: forall n a. (a -> Bool) -> Vec n a -> EVec ((>=) n) a
filter _ Nil = MkEVec Nil
filter p (x :> xs) | p x       = case filter p xs of MkEVec tail -> MkEVec (x :> tail)
                   | otherwise = case filter p xs of MkEVec v -> MkEVec v
-}

elem ∷ Eq a ⇒ a → Vec n a → Bool
elem _ Nil       = False
elem x (y :> ys) = (x == y) || elem x ys

type (<=) :: Nat → Nat → Constraint
class n <= m
instance n <= n
instance 'Zero <= n
-- instance (n <= m) => (n <= 'Succ m)

type (<&&>) :: (Nat → Constraint) → (Nat → Constraint) → Nat → Constraint
class (cond1 n, cond2 n) => (cond1 <&&> cond2) n
instance (cond1 n, cond2 n) ⇒ (cond1 <&&> cond2) n

{-
union :: Eq a => Vec n a -> Vec m a -> EVec ((<=) m) a
union xs Nil = MkEVec xs
union Nil ys = MkEVec ys
union (x :> xs) ys | x `elem` ys = case union xs ys of MkEVec u -> MkEVec u
                   | otherwise   = case union xs ys of MkEVec u -> MkEVec (x :> u)
-}
