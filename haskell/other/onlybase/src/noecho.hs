import           System.IO

main ∷ IO ()
main = do
    hSetEcho stdin False
    putStr "Enter your super secret password: "
    y <- getLine
    putStrLn $ "\nSo... it sounds like your password might have been " <> y
    putStrLn "Sorry about that."
