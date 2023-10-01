{-# LANGUAGE Safe         #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module MagicString where

import Data.String

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

-- >>> "a" "b"
-- Couldn't match expected type: String -> t_a5umH[sk:1]
--             with actual type: [Char]
-- The function `"a"' is applied to one value argument,
--   but its type `[Char]' has none
-- In the expression: "a" "b"
-- In an equation for `it_a5ulC': it_a5ulC = "a" "b"
-- Relevant bindings include
--   it_a5ulC :: t_a5umH[sk:1]
--     (bound at /home/dwd/code/mine/multi/projects/haskell/other/onlybase/lib/MagicString.hs:20:2)
instance (a ~ String, b ~ IO ()) ⇒ IsString (a → b) where
    fromString a b = do
        putStrLn a
        putStrLn b
