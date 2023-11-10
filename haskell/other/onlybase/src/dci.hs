{-# OPTIONS_GHC -Wno-orphans -Wno-unused-top-binds #-}

module Main (main) where

import GHC.Read
import Text.ParserCombinators.ReadP
import Text.ParserCombinators.ReadPrec (lift)

commandParser ∷ ReadP (IO ())
commandParser = do
    cmd <- many get
    pure . putStrLn $ ("Command was " <> cmd)

instance Read (IO ()) where
    readPrec = lift commandParser

parseAndPerform ∷ IO ()
parseAndPerform = do
    cmd <- getLine
    read cmd

main ∷ IO ()
main = parseAndPerform
