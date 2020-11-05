{-# LANGUAGE UnicodeSyntax #-}
module Data.List.Repeat (takeUntilRepeat) where

takeUntilRepeat ∷ Eq a ⇒ [a] → [a]
takeUntilRepeat xs = ((++) <$> fmap fst <*> return . snd . last) .
    takeWhile (uncurry (/=)) $
    zip xs (tail xs)
