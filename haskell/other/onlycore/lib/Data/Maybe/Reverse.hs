module Data.Maybe.Reverse where

-- >>> reverseMaybe 3 Nothing
-- Just 3
--

-- >>> reverseMaybe 1 (Just 1)
-- Nothing
--

reverseMaybe :: a -> Maybe b -> Maybe a
reverseMaybe a Nothing = Just a
reverseMaybe _ (Just _) = Nothing