{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import Control.Monad.Identity
import Data.Aeson
import GHC.Generics

data Person f = Person {
    name :: f String,
    age :: f Int,
    profession :: f String
} deriving (Generic)

instance (Show (f String), Show (f Int)) => Show (Person f) where
    show (Person {name, age, profession}) =
        "Person { name = " <> show name <>
        ", age = " <> show age <>
        ", profession = " <> show profession <>
        "}"

instance (FromJSON (f String), FromJSON (f Int)) => FromJSON (Person f)

instance (ToJSON (f String), ToJSON (f Int)) => ToJSON (Person f)

{- PERSON 2 -}

data Person2 f s i = Person2 {
    name2 :: f s,
    age2 :: f i,
    profession2 :: f s
} deriving (Generic)

instance (Show (f s), Show (f i)) => Show (Person2 f s i) where
    show (Person2 {name2, age2, profession2}) =
        "Person2 { name2 = " <> show name2 <>
        ", age2 = " <> show age2 <>
        ", profession2 = " <> show profession2 <>
        "}"

instance (FromJSON (f s), FromJSON (f i)) => FromJSON (Person2 f s i)

instance (ToJSON (f s), ToJSON (f i)) => ToJSON (Person2 f s i)

{- PERSON 3 -}

data Person3 f g = Person3 {
    name3 :: f String,
    age3 :: g Int,
    profession3 :: f String
} deriving (Generic)

instance (Show (f String), Show (g Int)) => Show (Person3 f g) where
    show (Person3 {name3, age3, profession3}) =
        "Person3 { name3 = " <> show name3 <>
        ", age3 = " <> show age3 <>
        ", profession3 = " <> show profession3 <>
        "}"

instance (FromJSON (f String), FromJSON (g Int)) => FromJSON (Person3 f g)

instance (ToJSON (f String), ToJSON (g Int)) => ToJSON (Person3 f g)

p3 :: Person3 Identity Identity
p3 = Person3 (Identity "Dan") (Identity 29) (Identity "Coder")

ptrans3 :: Person3 ((->) String) ((->) Int)
ptrans3 = Person3 {
    name3 = (<> "!"),
    age3 = succ,
    profession3 = (<> ".")
}

fmap3 :: (Functor f, Functor g) => Person3 ((->) String) ((->) Int) -> Person3 f g -> Person3 f g
fmap3 (Person3 nt at pt) (Person3 n a p) = Person3 (nt <$> n) (at <$> a) (pt <$> p)

pt3 :: Person3 Identity Identity
pt3 = fmap3 ptrans3 p3

{- PERSON 4 -}

data Person4 f g s i = Person4 {
    name4 :: f s,
    age4 :: g i,
    profession4 :: f s
} deriving (Generic)

instance (Show (f s), Show (g i)) => Show (Person4 f g s i) where
    show (Person4 {name4, age4, profession4}) =
        "Person4 { name4 = " <> show name4 <>
        ", age4 = " <> show age4 <>
        ", profession4 = " <> show profession4 <>
        "}"

instance (FromJSON (f s), FromJSON (g i)) => FromJSON (Person4 f g s i)

instance (ToJSON (f s), ToJSON (g i)) => ToJSON (Person4 f g s i)

p4 :: Person4 Identity Identity String Int
p4 = Person4 (Identity "Dan") (Identity 29) (Identity "Coder")

ptrans4 :: Person4 ((->) String) ((->) Int) String Int
ptrans4 = Person4 {
    name4 = (<> "!"),
    age4 = succ :: (Int -> Int),
    profession4 = (<> ".")
}

fmap4 :: (Functor f, Functor g) => Person4 ((->) s) ((->) i) s i -> Person4 f g s i -> Person4 f g s i
fmap4 (Person4 nt at pt) (Person4 n a p) = Person4 (nt <$> n) (at <$> a) (pt <$> p)

pt4 :: Person4 Identity Identity String Int
pt4 = fmap4 ptrans4 p4

{- PERSON 5 -}

type ToSame a = a -> a

-- It's a wrapper for... binary things?

data Person5 a b c = Person5 {
    name5 :: a b c
} deriving (Generic)

instance (Show (a b c)) => Show (Person5 a b c) where
    show (Person5 n) =
        "Person5 { name5 = " <> show n <> " }"

instance (FromJSON (a b c)) => FromJSON (Person5 a b c)

instance (ToJSON (a b c)) => ToJSON (Person5 a b c)

p5 :: Person5 (->) b b
p5 = Person5 {
    name5 = id
}

p5t :: Person5 (->) String String
p5t = Person5 {
    name5 = (<> "!")
}

p5s :: Person5 (->) a String
p5s = Person5 {
    name5 = const "Bob" 
}

app5 :: Person5 (->) (a1 b1 c1) (a2 b2 c2) -> Person5 a1 b1 c1 -> Person5 a2 b2 c2
app5 (Person5 nt) (Person5 n) = Person5 (nt n)

fmap5 :: Functor (a b) => Person5 (->) d c -> Person5 a b d -> Person5 a b c
fmap5 (Person5 nt) (Person5 n) = Person5 (nt <$> n)

{- MAIN STUFF -}

printAndEncode :: (Show a, ToJSON a) => a -> IO ()
printAndEncode x = do
    print x
    print . encode $ x

main ∷ IO ()
main = do
    printAndEncode $ Person Nothing Nothing Nothing
    printAndEncode $ Person (Just "Dan") (Just 29) (Just "Coder")
    printAndEncode $ Person (Identity "Dan") (Identity 29) (Identity "Coder")
    printAndEncode $ Person ["Dan"] [29] ["Coder"]

    printAndEncode (Person2 Nothing Nothing Nothing :: Person2 Maybe String Int)
    printAndEncode (Person2 (Just "Dan") (Just 29) (Just "Coder") :: Person2 Maybe String Int)
    printAndEncode (Person2 (Identity "Dan") (Identity 29) (Identity "Coder") :: Person2 Identity String Int)
    printAndEncode (Person2 ["Dan"] [29] ["Coder"] :: Person2 [] String Int)

    printAndEncode p3
    printAndEncode pt3

    printAndEncode p4
    printAndEncode pt4