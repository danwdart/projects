{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wno-unused-matches #-}

data Combination = Sum Combination Combination |
    Product Combination Combination |
    Plain Int |
    Root Int

instance Show Combination where
    show (Sum c1 c2)     = "(" <> (show c1 <> (" + " <> (show c2 <> ")")))
    show (Product c1 c2) = "(" <> (show c1 <> (show c2 <> ")"))
    show (Plain a)       = show a
    show (Root a)        = "√" <> show a

instance Num Combination where
    c1 + c2 = undefined
    c1 * c2 = undefined
    abs c1 = undefined
    signum c1 = undefined
    negate c1 = undefined
    fromInteger = Plain . fromInteger

main ∷ IO ()
main = print $ Sum (Product (Plain 2) (Root 2)) (Product (Plain 3) (Root 3))
