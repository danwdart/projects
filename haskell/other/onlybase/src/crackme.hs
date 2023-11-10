module Main (main) where

import System.IO

main ∷ IO ()
main = do
    putStrLn "Crack me!"
    putStr "Enter password: "
    hSetEcho stdin False
    pw <- getLine
    hSetEcho stdin True
    putStrLn ""
    if pw == "hello"
    then
        putStrLn "Hi!"
    else
        putStrLn "Wrong password."
