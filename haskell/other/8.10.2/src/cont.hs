{-# LANGUAGE UnicodeSyntax #-}
-- Cont demo
import           Control.Monad.Cont
import           System.Directory
import           System.IO

-- It's like a JS callback that can interrupt stuff
main ∷ IO ()
main = do
    print $ runCont (cont ($ (34 :: Int))) (*2)
    print $ runCont (ContT ($ (34 :: Int))) Just
    flip runContT print . callCC $ (\exit -> do
        liftIO . putStr $ "Enter name of file: "
        fileName <- liftIO getLine
        exists <- liftIO $ doesFileExist fileName
        unless exists $ do
            liftIO . putStrLn $ "File doesn't exist."
            exit []
        p <- liftIO . getPermissions $ fileName
        let r = readable p
        unless r $ do
            liftIO . putStrLn $ "File isn't readable."
            exit []
        h <- ContT $ withFile fileName ReadMode
        liftIO . putStrLn $ ("First ten lines of " <> fileName <> ":")
        replicateM 10 . liftIO $ hGetLine h)
