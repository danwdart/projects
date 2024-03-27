{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Main (main) where

import Shell

main ∷ IO ()
main = do
    ls
    cat "/etc/passwd"
