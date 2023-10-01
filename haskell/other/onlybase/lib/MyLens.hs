{-# LANGUAGE Safe #-}
{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-type-defaults #-}

module MyLens where

-- Libs

newtype Identity a = Identity { runIdentity :: a }

instance Functor Identity where
    fmap f (Identity a) = Identity $ f a

newtype Const b a = Const { runConst :: b }

instance Functor (Const b) where
    fmap _ (Const b) = Const b

-- Lens

type Lens s t a b = forall f. Functor f ⇒ (a → f b) → s → f t

type Lens' s a = Lens s s a a

lens ∷ (s → a) → (s → b → t) → Lens s t a b
lens sa sbt afa s = sbt s <$> afa (sa s)

view ∷ Lens s t a b → s → a
view l s = runConst $ l Const s

(^.) ∷ Lens s t a b → s → a
(^.) = view

infixl 8 ^.

set ∷ Lens s t a b  → b → s → t
set l a s = runIdentity $ l (const (Identity a)) s

(.~) ∷ Lens s t a b  → b → s → t
(.~) = set

infixr 4 .~

over ∷ Lens s t a b → (a → b) → s → t
over l f s = runIdentity $ l (Identity . f) s

(%~) ∷ Lens s t a b → (a → b) → s → t
(%~) = over

infixr 4 %~
