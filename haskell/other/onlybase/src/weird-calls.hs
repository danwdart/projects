{-# LANGUAGE UnicodeSyntax #-}
module Main where

import           Control.Monad

main ∷ IO ()
main = do
    print $ dupMonad (+) 12
    print $ bindFnInt succ (+) 2

{-
 $> :t join @((->) Int)
 join @((->) Int)
  :: Monad ((->) Int) => (Int -> (Int -> a)) -> Int -> a
-}
dupMonad ∷ (Int → Int → Int) → Int → Int
dupMonad = join

{-
 $> :t (>>=) @((->) Int)
 (>>=) @((->) Int) :: (Int -> a) -> (a -> Int -> b) -> Int -> b
-}
bindFn ∷ (a → b) → (b → a → c) → a → c
bindFn = (>>=)

bindFnInt ∷ (Int → Int) → (Int → Int → Int) → Int → Int
bindFnInt = (>>=)
