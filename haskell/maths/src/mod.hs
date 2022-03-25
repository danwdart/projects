{-# LANGUAGE UnicodeSyntax #-}
main ∷ IO ()
main = pure ()

newtype ModNine a = ModNine Int

instance (Num a) ⇒ Num (ModNine a) where
    ModNine a + ModNine b = ModNine $ mod (a + b) 9
    ModNine a - ModNine b = ModNine $ mod (a - b) 9
    ModNine a * ModNine b = ModNine $ mod (a * b) 9
    negate (ModNine a) = ModNine (9 - a)
    abs a = a
    signum _ = 1
    fromInteger a = ModNine $ mod (fromInteger a) 9

instance (Show a) ⇒ Show (ModNine a) where
    show (ModNine a) = show $ mod a 9
