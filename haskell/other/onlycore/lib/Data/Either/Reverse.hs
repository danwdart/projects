module Data.Either.Reverse where

-- >>> reverseEither 1 2 (Right 3)
-- Left 1
--

-- >>> reverseEither 1 2 (Left 3)
-- Right 2
--

reverseEither ∷ a → b → Either c d → Either a b
reverseEither _ b (Left _)  = Right b
reverseEither a _ (Right _) = Left a
