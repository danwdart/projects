main :: IO ()
main = do
    putStrLn "Hello"
    line <- getLine
    if line == "exit"
        then putStrLn "exit"
        else do               -- Note this!
    name <- getLine
    putStrLn ("Hello " ++ name)