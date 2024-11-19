module Main (main) where

import Data.Char
import Propagator

main ∷ IO ()
main = do
    putStrLn "SCENARIO 1"
    putStrLn "Adding a new cell lower."
    lower <- cell "lower"
    putStrLn "Adding a new cell upper."
    upper <- cell "upper"
    putStrLn "Adding a new lift."
    lift toUpper lower upper
    putStrLn "Adding the iso lift."
    lift toLower upper lower
    putStrLn "Writing a to lower manually."
    write lower (Just 'a')
    putStrLn "Getting content of upper manually."
    c <- content upper
    putStrLn "lift toUpper of a"
    print c

    putStrLn ""
    putStrLn "SCENARIO 2"
    putStrLn "Creating cell inL."
    inL <- cell "inL"
    putStrLn "Creating cell inR."
    inR <- cell "inR"
    putStrLn "Creating cell out."
    out <- cell "out"
    putStrLn "Initiating one-directional adder."
    adder inL inR out
    putStrLn "Writing 1 to inL manually."
    write inL (Just 1)
    putStrLn "Extracting out manually."
    c' <- content out
    putStrLn "adder of 1"
    print c'
    putStrLn "Writing 2 to inR manually."
    write inR (Just 2)
    putStrLn "Reading out manually."
    c2 <- content out
    putStrLn "adder of 2 also"
    print c2

    putStrLn ""
    putStrLn "SCENARIO 3"
    inL2 <- cell "inL2"
    inR2 <- cell "inR2"
    out2 <- cell "out2"
    adderBi inL2 inR2 out2
    putStrLn "Writing 1 to inL2 manually."
    write inL2 (Just 1)
    putStrLn "Writing 1 to out2 manually."
    write out2 (Just 1)
    putStrLn "Extracting content of inR2 manually."
    c3 <- content inR2
    putStrLn "adderBi of 1 and 1, backwards"
    print c3

    where
        adder ∷ Cell Int → Cell Int → Cell Int → IO ()
        adder l r o = do
            putStrLn "Adder created."
            lift2 (+) l r o

        adderBi ∷ Cell Int → Cell Int → Cell Int → IO ()
        adderBi l r o = do
            putStrLn "adderBi created."
            lift2 (+) l r o
            lift2 (-) o l r
            lift2 (-) o r l
