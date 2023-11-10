module Main (main) where

import GHC.IO.Handle.FD
import System.IO

main ∷ IO ()
main = do
    h <- fdToHandle 3
    hPutStrLn h "Debug"
