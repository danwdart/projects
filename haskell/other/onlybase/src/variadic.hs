{-# OPTIONS_GHC -Wno-type-defaults #-}

class PrintAllType t where
    printAll' :: [String] → t

instance PrintAllType (IO a) where
    printAll' acc = do print acc
                       pure undefined

instance (Show a, PrintAllType r) ⇒ PrintAllType (a → r) where
    printAll' acc x = printAll' (acc <> [show x])

printAll ∷ (PrintAllType t) ⇒ t
printAll = printAll' []

main ∷ IO ()
main = do
    _ <- printAll 5 "Mary" "had" "a" "little" "lamb" 4.2
    printAll 4 3 5
