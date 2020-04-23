import Control.Monad.Cont
import Control.Monad.IO.Class

-- welcome :: String
-- welcome = "Welcome to ARSVX. Use of this system by unauthorised entities is prohibited."

-- process :: String -> String
-- process a = "You said: " ++ a
{-
cli :: ContT () IO String
cli = do
    putStr "default@arsvx:~$ "
    line <- getLine
    if "q" == line then callCC (\k -> putStrLn "bye") else void
        putStrLn $ process line
        callCC cli
-}

main :: IO ()
main = void $ flip runContT return $ callCC $ \k -> do
    liftIO . putStrLn $ "AAA"
    _ <- k "bob" -- stops execution
    liftIO . putStrLn $ "BBB"
    return "yo"
 {-do
    putStrLn welcome
    runContT cli-}