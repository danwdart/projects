{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wwarn #-}

module Main (main) where

-- import Data.Bifunctor
import Control.Arrow              ((***))
import Data.Functor.Contravariant ()
import Data.Tuple                 (swap)
-- import Control.Category (Category)
-- import Data.Bifunctor

class Functor w => Comonad w where
    -- todo fill this in

data Isomorphism a b = Isomorphism (a → b) (b → a)

class Invariant f where
    imap :: (b → a) → (a → b) → f a → f b

newtype Endo a = Endo (a → a)

instance Invariant Endo where
    imap :: (b → a) → (a → b) → Endo a → Endo b
    imap f g (Endo e) = Endo (g . e . f)

iso ∷ Invariant f ⇒ Isomorphism a b → f a → f b
iso (Isomorphism to from) = imap from to

class Profunctor p where
    dimap :: (a → b) → (c → d) → p b c → p a d
    dimap l r = lmap l . rmap r

    lmap :: (a → b) → p b c → p a c
    lmap l = dimap l id

    rmap :: (b → c) → p a b → p a c
    rmap = dimap id

    {-# MINIMAL dimap | (lmap, rmap) #-}

instance Profunctor (->) where
    dimap :: (a → b) → (c → d) → (b → c) → a → d
    dimap f g k = g . k . f

isoP ∷ Profunctor p ⇒ Isomorphism a b → p a a → p b b
isoP (Isomorphism to from) = dimap from to

swapping ∷ Profunctor p ⇒ p (a, b) (x, y) → p (b, a) (y, x)
swapping = dimap swap swap

assoc ∷ Profunctor p ⇒ p ((a, b), c) ((x, y), z) → p (a, (b, c)) (x, (y, z))
assoc = dimap (\(a, (b, c)) -> ((a, b), c)) (\((a, b), c) -> (a, (b, c)))

-- >>> :t swapping . swapping
-- swapping . swapping
--   :: Profunctor p => p (b, a) (y, x) -> p (b, a) (y, x)
--

-- >>> :t assoc . swapping
-- assoc . swapping
--   :: Profunctor p =>
--      p (c, (a, b)) (z, (x, y)) -> p (a, (b, c)) (x, (y, z))
--

class Profunctor p => Strong p where
    first' :: p a b → p (a, x) (b, x)
    second' :: p a b → p (x, a) (x, b)

class Profunctor p => Choice p where
    left' :: p a b → p (Either a x) (Either b x)
    right' :: p a b → p (Either x a) (Either x b)


instance Strong (->) where
    first' :: (a → b) → (a, x) → (b, x)
    first' f (a, x) = (f a, x)

    second' :: (a → b) → (x, a) → (x, b)
    second' f (x, a) = (x, f a)

instance Choice (->) where
    left' :: (a → b) → Either a x → Either b x
    left' f (Left a)  = Left (f a)
    left' _ (Right x) = Right x

    right' :: (a → b) → Either x a → Either x b
    right' _ (Left x)  = Left x
    right' f (Right a) = Right (f a)



-- >>> :t first'
-- first' :: Strong p => p a b -> p (a, x) (b, x)
--

-- >>> :t first' . first'
-- first' . first' :: Strong p => p a b -> p ((a, x1), x2) ((b, x1), x2)
--

-- >>> :t first' . second'
-- first' . second'
--   :: Strong p => p a b -> p ((x1, a), x2) ((x1, b), x2)
--

-- >>> :t assoc . first'
-- assoc . first'
--   :: Strong p => p (a, b) (x, y) -> p (a, (b, z)) (x, (y, z))
--

-- >>> :t swapping . first'
-- swapping . first' :: Strong p => p a x -> p (y, a) (y, x)
--

-- >>> :t first' . swapping
-- first' . swapping
--   :: Strong p => p (a, b) (x1, y) -> p ((b, a), x2) ((y, x1), x2)
--

-- >>> :t left'
-- left' :: Choice p => p a b -> p (Either a x) (Either b x)
--

-- >>> :t left' . left'
-- left' . left'
--   :: Choice p =>
--      p a b -> p (Either (Either a x1) x2) (Either (Either b x1) x2)
--

-- >>> :t left' . right'
-- left' . right'
--   :: Choice p =>
--      p a b -> p (Either (Either x1 a) x2) (Either (Either x1 b) x2)
--

-- >>> :t first' . left'
-- first' . left'
--   :: (Strong p, Choice p) =>
--      p a b -> p (Either a x1, x2) (Either b x1, x2)
--

newtype Forget r a b = Forget { runForget :: a → r }

instance Profunctor (Forget r) where
    dimap :: (a → b) → (c → d) → Forget r b c → Forget r a d
    dimap f _ (Forget forget) = Forget (forget . f)

instance Strong (Forget r) where
    first' :: Forget r a b → Forget r (a, x) (b, x)
    first' (Forget f) = Forget (f . fst)

    second' :: Forget r a b → Forget r (x, a) (x, b)
    second' (Forget f) = Forget (f . snd)

instance Monoid m ⇒ Choice (Forget m) where
    left' :: Monoid m ⇒ Forget m a b → Forget m (Either a x) (Either b x)
    left' (Forget f) = Forget $ \case
        Left a -> f a
        Right _ -> mempty

    right' :: Monoid m ⇒ Forget m a b → Forget m (Either x a) (Either x b)
    right' (Forget f) = Forget $ \case
        Left _ -> mempty
        Right a -> f a

-- >>> runForget (first' . second' $ Forget id) $ (first' . second') succ $ ((1, 2), 3)
-- 3
--

-- >>> runForget (right' $ Forget id) $ (Right "Hello" :: Either String String)
-- "Hello"
--

-- >>> runForget (left' $ Forget id) $ (Right "Hello" :: Either String String)
-- ""
--

-- >>> runForget (right' $ Forget id) $ (Left "Hello" :: Either String String)
-- ""
--

-- >>> runForget (left' $ Forget id) $ (Left "Hello" :: Either String String)
-- "Hello"
--

newtype Star f a b = Star { runStar :: a → f b }

instance Functor f ⇒ Profunctor (Star f) where
    dimap :: Functor f ⇒ (a → b) → (c → d) → Star f b c → Star f a d
    dimap f g (Star star) = Star (fmap g . star . f)

{-
instance Functor f => Strong (Star f) where
    first' :: Functor f => Star f a b -> Star f (a, x) (b, x)
    first' (Star afb) = Star _

    second' :: Functor f => Star f a b -> Star f (x, a) (x, b)
    second' (Star f) = Star _

instance Applicative f => Choice (Star f) where
    left' :: Applicative f => Star f a b -> Star f (Either a x) (Either b x)
    left' = _

    right' :: Applicative f => Star f a b -> Star f (Either x a) (Either x b)
    right' = _
-}

newtype Costar f a b = Costar { runCostar :: f a → b }

instance Functor f ⇒ Profunctor (Costar f) where
    dimap :: (a → b) → (c → d) → Costar f b c → Costar f a d
    dimap f g (Costar costar) = Costar (g . costar . fmap f)

{-
instance Comonad w => Strong (Costar w) where
    first' :: Comonad w => Costar w a b -> Costar w (a, x) (b, x)
    first' (Costar f) = Costar _

    second' :: Comonad w => Costar w a b -> Costar w (x, a) (x, b)
    second' (Costar f) = Costar _

instance Comonad w => Choice (Costar w) where
    left' :: Comonad w => Costar w a b -> Costar w (Either a x) (Either b x)
    left' = _

    right' :: Comonad w => Costar w a b -> Costar w (Either x a) (Either x b)
    right' = _
-}

newtype Fold m a b = Fold { runFold :: (b → m) → a → m }

instance Profunctor (Fold m) where
    dimap :: (a → b) → (c → d) → Fold m b c → Fold m a d
    dimap f g (Fold fold) = Fold $ \k -> fold (k . g) . f

{-
instance Strong (Fold m) where
    first' :: Fold m a b -> Fold m (a, x) (b, x)
    first' (Fold m) = _

    second' :: Fold m a b -> Fold m (x, a) (x, b)
    second' = _

instance Monoid m => Choice (Fold m) where
    left' :: Monoid m => Fold m a b -> Fold m (Either a x) (Either b x)
    left' = _

    right' :: Monoid m => Fold m a b -> Fold m (Either x a) (Either x b)
    right' = _
-}

newtype Mealy a b = Mealy { runMealy :: a → (b, Mealy a b) }

instance Profunctor Mealy where
    dimap :: (a → b) → (c → d) → Mealy b c → Mealy a d
    dimap f g = go
        where
            go (Mealy mealy) = Mealy $ (g *** go) . mealy . f

{-
instance Strong Mealy where
    first' :: Mealy a b -> Mealy (a, x) (b, x)
    first' = _

    second' :: Mealy a b -> Mealy (x, a) (x, b)
    second' = _

instance Choice Mealy where
    left' :: Mealy a b -> Mealy (Either a x) (Either b x)
    left' = _

    right' :: Mealy a b -> Mealy (Either x a) (Either x b)
    right' = _
-}

{-
class (Strong a, Category a) => Arrow a

instance Arrow (->)

instance Applicative f => Arrow (Star f)

instance Comonad w => Arrow (Costar w)

instance Monoid m => Arrow (Fold m)

instance Arrow Mealy
-}

-- use traverse
-- view over preview .~ ^.

-- type Iso s t a b = forall p. Profunctor p => p a b -> p s t
-- type Lens s t a b = forall p. Strong p => p a b -> p s t
-- type Prism s t a b = forall p. Choice p => p a b -> p s t


class Profunctor p => Closed p where
    closed :: p a b → p (x → a) (x → b)

class (Strong p, Choice p) => Traversing p where
    traversing :: Traversable t ⇒ p a b → p (t a) (t b)

type AffineTraversal s t a b = forall p. (Strong p, Choice p) ⇒ p a b → p s t
type Optic c s t a b = forall p. c p ⇒ p a b → p s t
type Iso s t a b = Optic Profunctor s t a b
type Lens s t a b = Optic Strong s t a b
type Prism s t a b = Optic Choice s t a b
type Traversal s t a b = Optic Traversing s t a b
type Grate s t a b = Optic Closed s t a b
-- type SEC s t a b = Optic ( (->) (~)  ) s t a b

-- >>> :t first' . closed


-- >>> :t first' . left' :: AffineTraversal (Either a x1, x2) (Either b x1, x2) a b
-- first' . left' :: AffineTraversal (Either a x1, x2) (Either b x1, x2) a b
--   :: AffineTraversal (Either a x1, x2) (Either b x1, x2) a b
--

iso2lens ∷ Iso s t (a, x) (b, x) → Lens s t a b
iso2lens iso' pab = iso' (first' pab)

-- lens2iso :: Lens s t a b -> exists x. iso s t (a, x) (b, x)

iso2prism ∷ Iso s t (Either a x) (Either b x) → Prism s t a b
iso2prism iso' pab = iso' (left' pab)

nf ∷ (s → (a, x)) → ((b, x) → t) → Lens s t a b
nf f g pab = dimap f g (first' pab)

nf2 ∷ Iso s t (a, x) (b, x) → Lens s t a b
nf2 iso' pab = iso' (first' pab)


get ∷ Lens s t a b → s → a
get lens = runForget (lens (Forget id))

set ∷ Lens s t a b → b → s → t
set lens b = lens (const b)

modify ∷ Lens s t a b → (a → b) → s → t
modify lens = lens

-- >>> modify traversing succ [1, 2, 3]
-- <interactive>:10837:9-18: error:
--     • Could not deduce (Traversing p)
--         arising from a use of ‘traversing’
--       from the context: (Enum a, Num a)
--         bound by the inferred type of it :: (Enum a, Num a) => [a]
--         at <interactive>:10837:2-33
--       or from: Strong p
--         bound by a type expected by the context:
--                    Lens [a] [a] a a
--         at <interactive>:10837:9-18
--       Possible fix:
--         add (Traversing p) to the context of
--           a type expected by the context:
--             Lens [a] [a] a a
--     • In the first argument of ‘modify’, namely ‘traversing’
--       In the expression: modify traversing succ [1, 2, 3]
--       In an equation for ‘it’: it = modify traversing succ [1, 2, 3]
--


data Pick = MkPick {
    firstField'  :: String,
    secondField' :: Int
} deriving (Eq, Show)

firstField ∷ (String → String) → Pick → Pick
firstField f pick@MkPick { firstField' = oldfirst'Field } = pick { firstField' = f oldfirst'Field }

myPick ∷ Pick
myPick = MkPick { firstField' = "Hello", secondField' = 42 }

main ∷ IO ()
main = pure ()
