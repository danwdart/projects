{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Main (main) where

-- Cont demo
import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Cont
import System.Directory
import System.IO

-- It's like a JS callback that can interrupt stuff
-- it also is like a replacement for withX, helping with resource pattern.
main ∷ IO ()
main = do
    print $ runCont (cont ($ (34 :: Int))) (*2)
    print $ runCont (ContT ($ (34 :: Int))) Just
    evalContT . callCC $ \exit -> do
        liftIO . putStr $ "Enter name of file: "
        fileName <- liftIO getLine
        exists <- liftIO $ doesFileExist fileName
        unless exists $ do
            liftIO . putStrLn $ "File doesn't exist."
            exit ()
        p <- liftIO . getPermissions $ fileName
        let r = readable p
        unless r $ do
            liftIO . putStrLn $ "File isn't readable."
            exit ()
        -- Resource pattern here
        h <- ContT $ withFile fileName ReadMode
        liftIO . putStrLn $ ("First ten lines of " <> fileName <> ":")
        lines' <- replicateM 10 . liftIO $ hGetLine h
        liftIO . print $ lines'
