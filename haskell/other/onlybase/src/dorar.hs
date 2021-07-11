{-# LANGUAGE UnicodeSyntax #-}
-- ap
main ∷ IO ()
main = print $ fmap ($ (3 :: Int)) [((4 :: Int)+),((7 :: Int)+)]

-- Params
-- sum (replicate 5 (max 6.7 8.9))

-- Compose
-- sum . replicate 5 . max 6.7 $ 8.9

-- No need to use blackbird, just use dot-dor
