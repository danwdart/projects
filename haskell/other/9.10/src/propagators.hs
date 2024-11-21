module Main (main) where

import Data.Char
import Propagator

main ∷ IO ()
main = do
    putStrLn "SCENARIO 1"
    lower <- cell
    upper <- cell
    lift toUpper lower upper
    lift toLower upper lower
    write lower 'a'
    c <- content upper
    print c

    putStrLn ""
    putStrLn "SCENARIO 2"
    inL <- cell @Int
    inR <- cell @Int
    out <- cell @Int
    adder inL inR out
    write inL 1
    c' <- content out
    print c'
    write inR 2
    c2 <- content out
    print c2

    putStrLn ""
    putStrLn "SCENARIO 3"
    inL2 <- cell @Int
    inR2 <- cell @Int
    out2 <- cell @Int
    adderBi inL2 inR2 out2
    write inL2 1
    write out2 1
    c3 <- content inR2
    putStrLn "adderBi of 1 and 1, backwards"
    print c3

    putStrLn ""
    putStrLn "SCENARIO 4"
    bool1 <- cell
    bool2 <- cell
    lift not bool1 bool2
    lift not bool2 bool1
    write bool1 True
    bool2Out <- content bool2
    print bool2Out

    putStrLn ""
    putStrLn "SCENARIO 5"
    boolRec1 <- cell
    boolRec2 <- cell
    boolRec3 <- cell
    lift not boolRec1 boolRec2
    lift not boolRec2 boolRec3
    lift not boolRec3 boolRec1
    write boolRec1 True
    print =<< traverse content [boolRec1, boolRec2, boolRec3]

    pure ()

    where
        adder ∷ (Num a, Eq a) ⇒ Cell a → Cell a → Cell a → IO ()
        adder l r o = do
            lift2 (+) l r o

        adderBi ∷ (Num a, Eq a) ⇒ Cell a → Cell a → Cell a → IO ()
        adderBi l r o = do
            lift2 (+) l r o
            lift2 (-) o l r
            lift2 (-) o r l
