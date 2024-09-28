{-# OPTIONS_GHC -Wno-type-defaults -Wwarn #-}

module Main (main) where

import Data.Functor.Contravariant           hiding ((>$<))
import Data.Functor.Contravariant.Divisible
import Data.Void

class Ppr a where
    ppr :: a → String

--  https://www.youtube.com/watch?v=IJ_bVVsQhvc
newtype Printer a = Printer {
    runPrinter :: a → String
}

string ∷ Printer String
string = Printer id

konst ∷ String → Printer a
konst = Printer . const

showP ∷ Show a ⇒ Printer a
showP = Printer show

int ∷ Printer Int
int = showP

nl ∷ Printer ()
nl = konst "\n"

instance Contravariant Printer where
    contramap ba (Printer as) = Printer (as . ba)

instance Divisible Printer where
    divide cab (Printer as) (Printer bs) = Printer $ \c ->
        case cab c of
            (a, b) -> as a <> bs b
    conquer = Printer $ const ""

instance Decidable Printer where
    choose cab (Printer as) (Printer bs) = Printer $ \c ->
        case cab c of
            Left a  -> as a
            Right b -> bs b
    lose av = Printer (absurd . av)

(>$<) ∷ Contravariant f ⇒ (b → a) → f a → f b
(>$<) = contramap

infixr 4 >$<

(>*<) ∷ Divisible f ⇒ f a → f b → f (a, b)
(>*<) = divide id

infixr 4 >*<

(>|<) ∷ Decidable f ⇒ f a → f b → f (Either a b)
(>|<) = choose id

infixr 3 >|<

(>*) ∷ Divisible f ⇒ f a → f () → f a
(>*) = divide (, ())

infixr 4 >*

(*<) ∷ Divisible f ⇒ f () → f a → f a
(*<) = divide ((), )

infixr *<

data Person = Person {
    name      :: String,
    age       :: Int,
    interests :: [String]
}

personToTuple ∷ Person → (String, (Int, [String]))
personToTuple Person {name, age, interests} = (name, (age, interests))

printPerson ∷ Printer Person
printPerson = personToTuple
    >$< (konst "Name: " *< string >* nl)
    >*< (konst "Age: " *< int >* nl)
    >*< (konst "Interests: " *< showP >* nl)

-- instance Ppr Person where

main ∷ IO ()
main = do
    print $ getOp ((++ "b") >$< Op show) "Bob"
    print $ getPredicate ((+ 1) >$< Predicate (== 2)) 1
    putStrLn . runPrinter printPerson $ Person "Dan" 30 ["Babby"]
