module Main (main) where

import Shape

main ∷ IO ()
main = print $ infoShape (Circle (Point 1.0 2.0) 3.0)
