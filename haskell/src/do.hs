main :: IO ()
main = do
    putStrLn "Hello"
    line <- getLine
    if line == "exit"
        then putStrLn "exit"
        else putStrLn "Wat?"               -- Note this!
    name <- getLine
    putStrLn ("Hello " ++ name)