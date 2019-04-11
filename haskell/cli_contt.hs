import Control.Monad.Cont

welcome :: String
welcome = "Welcome to ARSVX. Use of this system by unauthorised entities is prohibited."

process :: String -> String
process a = "You said: " ++ a

cli :: ContT () IO String
cli = do
    putStr "default@arsvx:~$ "
    line <- getLine
    if "q" == line then callCC putStrLn "bye" else do
        putStrLn $ process line
        callCC cli

main :: IO ()
main = do
    putStrLn welcome
    cli