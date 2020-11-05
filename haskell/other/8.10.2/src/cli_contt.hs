{-# LANGUAGE UnicodeSyntax #-}
import           Control.Monad.Cont

welcome ∷ String
welcome = "Welcome to ARSVX. Use of this system by unauthorised entities is prohibited."

process ∷ String → String
process a = "You said: " <> a

main ∷ IO ()
main = do
    putStrLn welcome
    void . flip runContT return $ callCC (\k -> do
        liftIO . putStr $ "default@arsvx:~$ "
        line <- liftIO getLine
        when (line == "q") $ k ()
        liftIO . putStrLn $ process line
        liftIO main)
