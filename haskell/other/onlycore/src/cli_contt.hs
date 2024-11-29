module Main (main) where

import Control.Monad          (unless, void, when)
import Control.Monad.Cont
import Control.Monad.IO.Class
import System.IO

welcome ∷ String
welcome = "Welcome to ARSVX. Use of this system by unauthorised entities is prohibited."

process' ∷ String → [String] → String
process' cmd args = "Command: " <> cmd <> ", args = " <> show args

process ∷ String → String
process a = case words a of
    []    -> "Nuthin'"
    (h:t) -> process' h t

main ∷ IO ()
main = do
    putStrLn welcome
    putStr "arsvx login: "
    void getLine
    putStr "Password: "
    hSetEcho stdin False
    void getLine
    hSetEcho stdin True
    putStrLn "\nSystem is healthy.\n"
    shell

shell ∷ IO ()
shell = (void . flip runContT pure) . callCC $ (\k -> do
    liftIO . putStr $ "default@arsvx:~$ "
    line <- liftIO getLine
    when (line == "q" || line == "\EOT") $ k ()
    unless (null (words line)) . liftIO . putStrLn $ process line
    liftIO shell)
