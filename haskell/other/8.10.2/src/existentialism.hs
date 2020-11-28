{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE MultiWayIf #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE UnicodeSyntax #-}

import Control.Exception
import Data.Typeable

-- https://blog.sumtypeofway.com/posts/existential-haskell.html

-- Inaccessible container for reifying a class?

data Showable = forall a . Show a => Showable a

showable :: Showable -> String
showable x = case x of Showable val -> show val

s :: Showable
s = Showable "Hi!"


data ShowableG where
  ShowableG :: Show a => a -> ShowableG

showableG :: ShowableG -> String
showableG x = case x of ShowableG val -> show val

sg :: ShowableG
sg = ShowableG "Hi!"

cautiouslyPrint :: Show a => IO a -> IO ()
cautiouslyPrint go = Control.Exception.catch (go >>= print) handler
  where
    handler :: SomeException -> IO ()
    handler (SomeException e) = if
      | Just (arith :: ArithException) <- cast e -> putStrLn ("arith: " <> show arith)
      | Just (array :: ArrayException) <- cast e -> putStrLn ("array: " <> show array)
      | otherwise -> putStrLn ("Something else: " <> show e)

main ∷ IO ()
main = do
  putStrLn $ showable s
  putStrLn $ showableG sg
  cautiouslyPrint . pure $ "Everything is fine."
  cautiouslyPrint $ (ioError . userError $ "AAAH!" :: IO String)