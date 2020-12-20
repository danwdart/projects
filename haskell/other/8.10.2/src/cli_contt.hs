{-# LANGUAGE UnicodeSyntax #-}
import           Control.Monad.Cont

welcome ∷ String
welcome = "Welcome to ARSVX. Use of this system by unauthorised entities is prohibited."

process' ∷ String → [String] → String
process' cmd args = "Command: " <> cmd <> ", args = " <> show args

process ∷ String → String
process a = process' (head x) (tail x) where
    x = words a

main ∷ IO ()
main = do
    putStrLn welcome
    shell

shell ∷ IO ()
shell = void . flip runContT return $ callCC $ \k -> do
    liftIO . putStr $ "default@arsvx:~$ "
    line <- liftIO getLine
    when (line == "q" || line == "\EOT") $ k ()
    when (line /= "") $
        liftIO . putStrLn $ process line
    liftIO shell