import Data.Char
import Propagator

main :: IO ()
main = do
    input <- cell
    output <- cell
    lift toUpper input output
    write input (Just 'a')
    c <- content output
    putStrLn "lift toUpper of a"
    print c

    inL <- cell
    inR <- cell
    out <- cell
    adder inL inR out
    write inL (Just 1)
    c' <- content out
    putStrLn "adder of 1"
    print c'

    write inR (Just 2)
    c2 <- content out
    putStrLn "adder of 2 also"
    print c2
    
    inL2 <- cell
    inR2 <- cell
    out2 <- cell
    adderBi inL2 inR2 out2
    write inL2 (Just 1)
    write out2 (Just 1)
    c3 <- content inR2
    putStrLn "adderBi of 1 and 1, backwards"
    print c3
    
    where
        adder :: Cell Int -> Cell Int -> Cell Int -> IO ()
        adder l r o = do
            lift2 (+) l r o

        adderBi :: Cell Int -> Cell Int -> Cell Int -> IO ()
        adderBi l r o = do
            lift2 (+) l r o
            lift2 (-) o l r
            lift2 (-) o r l