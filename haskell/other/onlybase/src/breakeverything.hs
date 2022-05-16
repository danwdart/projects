{-# LANGUAGE NoImplicitPrelude #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import           BreakEverything
import           Prelude (IO, Int, print, putStrLn, ($))

main ∷ IO ()
main = do
    putStrLn "I broke it."
    print $ (5 :: Int) * (3 :: Int)
