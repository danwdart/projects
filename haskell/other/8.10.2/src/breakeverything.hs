{-# LANGUAGE NoImplicitPrelude #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import           Prelude (IO, Int, Maybe (..), Num, Show, String, print,
                          putStrLn, show, ($), (++))

(+), (*) :: (Num a, Show a) => a -> a -> String
a + b = show a ++ show b
a * b = show [a] ++ show [b]

(/), div :: (Num a, Show a) => a -> a -> Maybe String

a / b = Just $ show a ++ "/" ++ show b
div a b = Just $ show a ++ " div " ++ show b

main :: IO ()
main = do
    putStrLn "I broke it."
    print $ (5 :: Int) * (3 :: Int)
