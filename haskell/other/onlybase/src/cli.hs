module Main (main) where

welcome ∷ String
welcome = "Welcome to ARSVX. Use of this system by unauthorised entities is prohibited."

process ∷ String → String
process a = a

cli ∷ IO ()
cli = do
    putStr "default@arsvx:~$ "
    line <- getLine
    if "q" == line || "\x04" == line then putStrLn "bye" else do
        putStrLn $ process line
        cli

main ∷ IO ()
main = do
    putStrLn welcome
    cli
