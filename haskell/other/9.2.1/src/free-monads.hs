{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE LambdaCase #-}
{-# OPTIONS_GHC -Wwarn #-}

-- https://serokell.io/blog/introduction-to-free-monads
import Control.Monad.Free

data ProgramF t a
  = Input (t -> a)
  | Output t a
  deriving Functor

program :: Free (ProgramF String) ()
program = do
  x <- liftF $ Input id
  liftF $ Output ("hi " <> x) ()

interpret :: Free (ProgramF String) () -> IO ()
interpret = foldFree $ \case
    Input f -> f <$> getLine
    Output x f -> do
        putStrLn x
        pure f

pretty :: Free (ProgramF String) () -> String
pretty (Pure _) = ""
pretty (Free f) = case f of
    Input next -> "Input (demo)\n" <> pretty (next "demo")
    Output x next -> "Output: " <> x <> pretty next

main :: IO ()
main = do
    putStrLn "Running this:"
    putStrLn $ pretty program
    putStrLn "Here we go:"
    interpret program