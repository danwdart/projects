{-# LANGUAGE CApiFFI #-}

kmain :: IO ()
kmain = putStrLn "Hello, Haskell!"

foreign export capi kmain :: IO ()