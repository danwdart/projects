module Main (main) where

import Cipher
import Control.Monad
import System.IO

main ∷ IO ()
main = do
    putStrLn $ cipher 2 "Hi world! My name is Bob!"
    forM_ [1..10] $ \n -> do
        putStr $ show n <> ": "
        putStrLn $ cipher n "Helo werld, mai neim iz bob."
    -- TODO cycling cipher
    putStrLn $ cyclingCipher "Aaaaaaaa, hello my friends! It is I, the Ruminating Demon!"
    hSetEcho stdout False
    interact cyclingCipher
    hSetEcho stdout True
