{-# OPTIONS_GHC -Wno-type-defaults #-}

import PrintAll

main ∷ IO ()
main = do
    _ <- printAll 5 "Mary" "had" "a" "little" "lamb" 4.2
    printAll 4 3 5
