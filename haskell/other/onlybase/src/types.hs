module Main (main) where

import Auth

main ∷ IO ()
main = print $ authenticate "bob@bob.com" "password"
