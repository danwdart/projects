{-# OPTIONS_GHC -Wno-type-defaults #-}

module Main (main) where

import Control.Monad (void)
import PrintAll

main ∷ IO ()
main = do
    void $ printAll 5 "Mary" "had" "a" "little" "lamb" 4.2
    printAll 4 3 5
