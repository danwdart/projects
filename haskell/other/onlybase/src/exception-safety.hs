{-# LANGUAGE DerivingVia #-}

module Main (main) where

import Control.Exception

-- import System.IO
-- now there's a try and an exception monad

-- This is just for IO exceptions and not for MonadError, that'll be somewhere else

tryRead ∷ String → IO (Either SomeException String)
tryRead = try . readFile

sampleIO ∷ IO ()
sampleIO = throwIO $ userError "Bob"

failer ∷ IO String
failer = fail "Bob"

tryer ∷ IO (Either SomeException String)
tryer = try failer

data DanException = DanException
    deriving stock (Show)

instance Exception DanException

sampleHandler ∷ SomeException → IO ()
sampleHandler (SomeException ex) = putStrLn $ "Caught error: (" <> displayException ex <> ")"

danHandler ∷ DanException → IO ()
danHandler d@DanException = putStrLn $ "Caught DanException: " <> displayException d

main ∷ IO ()
main = do
    tryRead "bob" >>= print
    writeFile "Jim" "Contents"
    tryRead "Jim" >>= print
    tryer >>= print
    sampleIO `catch` danHandler `catch` sampleHandler
    throwIO DanException `catch` danHandler `catch` sampleHandler
    throwIO (userError "Bob again") `catch` danHandler `catch` sampleHandler
    catch @DanException (throwIO DanException) danHandler
    catch @SomeException (throwIO $ userError "Bob again again") sampleHandler
