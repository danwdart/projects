{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-type-defaults #-}

import           Data.Function

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

_1 ∷ Lens (a, b) (c, b) a c
_1 = lens fst (\(_, b) c -> (c, b))

_2 ∷ Lens (a, b) (a, c) b c
_2 = lens snd (\(a, _) c -> (a, c))
-- Over triple

data Triple a b c = Triple {
    ta :: a,
    tb :: b,
    tc :: c
} deriving (Show)

lensTripleA ∷ Lens (Triple a b c) (Triple a' b c) a a'
lensTripleA = lens ta (\(Triple _ b c) a' -> Triple a' b c)

lensTripleB ∷ Lens (Triple a b c) (Triple a b' c) b b'
lensTripleB = lens tb (\(Triple a _ c) b' -> Triple a b' c)

lensTripleC ∷ Lens (Triple a b c) (Triple a b c') c c'
lensTripleC = lens tc (\(Triple a b _) c' -> Triple a b c')

data Title = Citizen | Professor | Doctor deriving (Show)

data Date = Date {
    _year  :: Int,
    _month :: Int,
    _day   :: Int
} deriving (Show)

year ∷ Lens' Date Int
year = lens _year (\date year' -> date { _year = year'})

month ∷ Lens' Date Int
month = lens _month (\date month' -> date { _month = month'})

day ∷ Lens' Date Int
day = lens _day (\date day' -> date { _day = day'})

data Name = Name {
    _title        :: Title,
    _givenName    :: String,
    _officialName :: String
} deriving (Show)

title ∷ Lens' Name Title
title = lens _title (\name' title' -> name' { _title = title' })

givenName ∷ Lens' Name String
givenName = lens _givenName (\name' givenName' -> name' { _givenName = givenName' })

officialName ∷ Lens' Name String
officialName = lens _officialName (\name' officialName' -> name' { _officialName = officialName' })

data Event = Event {
    _summary     :: String,
    _description :: String
} deriving (Show)

summary ∷ Lens' Event String
summary = lens _summary (\event summary' -> event { _summary = summary' })

description ∷ Lens' Event String
description = lens _description (\event description' -> event { _description = description' })

data Attributes = Attributes {
    _dob    :: Date,
    _events :: [(Date, Event)]
} deriving (Show)

dob ∷ Lens' Attributes Date
dob = lens _dob (\attributes' dob' -> attributes' { _dob = dob' })

events ∷ Lens' Attributes [(Date, Event)]
events = lens _events (\attributes' events' -> attributes' { _events = events' })

data Person = Person {
    _name       :: Name,
    _attributes :: Attributes
} deriving (Show)

name ∷ Lens' Person Name
name = lens _name (\person name' -> person { _name = name' })

attributes ∷ Lens' Person Attributes
attributes = lens _attributes (\person attributes' -> person { _attributes = attributes' })

defaultPerson ∷ Person
defaultPerson = Person (
        Name Doctor "Pickle" "James Robert Pickle"
    ) (
        Attributes (Date 1945 3 21) [
            (
                Date 1970 1 1,
                Event "Created universe" "Created the universe."
            ),
            (
                Date 1980 1 1,
                Event "Got tired" "Had enough of this nonsense."
            )
            ]
    )

newman ∷ Person
newman = defaultPerson
    & name . givenName .~ "Bobby"
    & name . officialName .~ "Bobby Jimbo III" -- TODO shortcut

main ∷ IO ()
main = do
    putStrLn $
        show (name . title ^. newman)
        <>
        " "
        <>
        (name . givenName ^. newman)
        <>
        ", also known as "
        <>
        (name . officialName ^. newman)
        <>
        " was set upon."
        -- <>
        -- show (attributes . events ^. newman)
    pure ()
    -- print $ set _1 "c" ("a", 1)
    -- print $ set _2 "b" (9, 9)
    -- print $ view _1 ("a", "b")
    -- print $ view _2 ("a", "b")
    -- print $ over _2 succ (1, 1)
    -- print $ over _1 succ (1, 1)
    -- print . set lensTripleA "llll" $ Triple 1 2 3
    -- print . set lensTripleB "bbbb" $ Triple 'a' 'b' 'c'
    -- print . set lensTripleC "bbbb" $ Triple True False True
