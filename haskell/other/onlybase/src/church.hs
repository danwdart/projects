{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-unused-matches #-}

main ∷ IO ()
main = pure ()

zero ∷ a → b → b
zero f x = x

one ∷ (a → b) → a → b
one f = f

two ∷ (a → a) → a → a
two f x = f (f x)

three ∷ (a → a) → a → a
three f x = f (f (f x))

plus ∷ (a → b → c) → (a → d → b) → a → d → c
plus m n f x = m f (n f x)

succ ∷ ((a → b) → c → a) → (a → b) → c → b
succ n f x = f (n f x)

mult ∷ (a → b → c) → (d → a) → d → b → c
mult m n f = m (n f)

exp ∷ a → (a → b) → b
exp m n = n m

-- pred n f x = ???
