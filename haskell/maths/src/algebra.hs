
newtype Variable x = Variable x

instance {-# OVERLAPPABLE #-} Show (Variable String) where
    show (Variable x) = x

instance {-# OVERLAPS #-} Show x ⇒ Show (Variable x) where
    show (Variable x) = show x

data Add x y = Add x y

instance (Show x, Show y) ⇒ Show (Add x y) where
    show (Add x y) = show x <> " + " <> show y
    -- todo showsPrec

data Mul x y = Mul x y

instance (Show x, Show y) ⇒ Show (Mul x y) where
    show (Mul x y) = show x <> " * " <> show y

main ∷ IO ()
main = do
    print $ Mul (Variable "x") (Variable "y")
    print $ Mul (Variable "x") (Add (Variable "y") (Variable "z"))
    print $ Mul (Variable (2 :: Int)) (Variable (3 :: Int))
