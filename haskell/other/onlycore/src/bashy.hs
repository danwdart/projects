{-# OPTIONS_GHC -Wno-unsafe #-}
{-# LANGUAGE Safe #-}

module Main (main) where

import Shell

main ∷ IO ()
main = do
    ls
    cat "/etc/passwd"
