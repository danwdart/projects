{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wno-type-defaults -Wno-unused-matches -Wno-name-shadowing #-}

{- TODO: Deriving -}

newtype Bob a = Bob a deriving (Show)

instance Functor Bob where
    fmap f (Bob x) = Bob (f x)

instance Applicative Bob where
    pure = Bob
    (Bob f) <*> (Bob x) = Bob (f x)

instance Monad Bob where
    (Bob x) >>= f = f x

-- List's a monad. What can we do with it?
a :: [Int]
a = do
    a <- pure 1 -- Arrow an element, you get it back.
    b <- pure 2
    -- pure a -- ignored!
    pure b -- Passed if last, and embedded.

b :: [Int]
b = do
    a <- [1..5] -- Arrow a list, you get it back.
    pure a

c1 :: [Int]
c1 = do
    a <- [1..5]
    b <- [1..10]
    pure a -- pure a, b times each, e.g. a1 a1 a1 a2 a2 a2

c2 :: [Int]
c2 = do
    a <- [1..5]
    [1..10] -- this, but a times, flattened, e.g. b1 b2 b3 b1 b2 b3

d :: [Int]
d = do
    a <- ([1..10] :: [Int])
    b <- ([1..2] :: [Int])
    c <- ([1..20] :: [Int])
    [1..5] :: [Int] -- you get all of the lists' lengths multiplied, with the values here.
    -- Quite surprising!

main ∷ IO ()
main = do
    print $ (*2) <$> Bob (2 :: Int)
    print a
    print b
    print c1
    print c2
    print d
