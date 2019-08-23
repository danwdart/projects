-- {-# LANGUAGE NoImplicitPrelude #-}

-- (+), (*) :: (Num a, Show a) => a -> a -> a
-- a + b = (show a) ++ (show b)
-- a * b = (show [a]) ++ (show [b])

-- (/), div :: (Num a, Show a) => a -> a -> Maybe a

--a / b = Just $ (show a) ++ "/" ++ (show b)
-- div a b = Just $ (show a) ++ " div " ++ (show b)

main :: IO ()
main = do
    putStrLn "I broke it."
    -- print $ 5 * 3