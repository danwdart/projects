module PrintAll where
    
class PrintAllType t where
    printAll' :: [String] → t

instance PrintAllType (IO a) where
    printAll' acc = do print acc
                       pure undefined

instance (Show a, PrintAllType r) ⇒ PrintAllType (a → r) where
    printAll' acc x = printAll' (acc <> [show x])

printAll ∷ (PrintAllType t) ⇒ t
printAll = printAll' []