module Main (main) where

main ∷ IO ()
main = pure ()

newtype ModNine a = ModNine a

instance (Num a, Integral a) ⇒ Num (ModNine a) where
    ModNine a + ModNine b = ModNine $ mod (a + b) 9
    ModNine a - ModNine b = ModNine $ mod (a - b) 9
    ModNine a * ModNine b = ModNine $ mod (a * b) 9
    negate (ModNine a) = ModNine (9 - a)
    abs a = a
    signum _ = 1
    fromInteger a = ModNine $ mod (fromIntegral a) 9

-- newtype Mod n a = Mod a
-- 
-- instance (Num a, Integral a) ⇒ Num (Mod a) where
--    ModNine a + ModNine b = ModNine $ mod (a + b) 9
--    ModNine a - ModNine b = ModNine $ mod (a - b) 9
--    ModNine a * ModNine b = ModNine $ mod (a * b) 9
--    negate (ModNine a) = ModNine (9 - a)
--    abs a = a
--    signum _ = 1
--    fromInteger a = ModNine $ mod (fromIntegral a) 9


-- why is that redundant?
instance (Show a, Integral a) ⇒ Show (ModNine a) where
    show (ModNine a) = show $ mod a 9
