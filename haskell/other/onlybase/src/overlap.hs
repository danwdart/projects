{-# LANGUAGE IncoherentInstances  #-}
{-# LANGUAGE UndecidableInstances #-}

module Main (main) where

class Special a where
    showspecial :: a → String

instance {-# OVERLAPPABLE #-} (Show a) ⇒ Special a where
    showspecial a = "Show Special Default: " <> show a

instance {-# OVERLAPPING #-} Special Int where
    showspecial a = "Special Int: " <> show a

instance {-# OVERLAPPING #-} (Show a) ⇒ Special [a] where
    showspecial as = "A list of " <> showspecial as

main ∷ IO ()
main = do
    putStrLn . showspecial $ (5 :: Int)
    putStrLn . showspecial $ "euh?"
