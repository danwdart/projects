{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies      #-}
{-# OPTIONS_GHC -Wno-orphans #-}

import           Data.String

-- Why won't this work
{-}
instance IsString (String -> IO ()) where
    fromString a b = do
        putStrLn a
        putStrLn b
-}

-- Whereas these will

-- instance IsString (IO ()) where
--     fromString a = putStrLn a

instance (a ~ String, b ~ IO ()) ⇒ IsString (a → b) where
    fromString a b = do
        putStrLn a
        putStrLn b

main ∷ IO ()
main = do
    "hi" "hey"
