{-# LANGUAGE DeriveAnyClass #-}

import           Control.Exception
import           Control.Monad.Fail
import           GHC.Stack

-- import System.IO
-- now there's a try and an exception monad

-- This is just for IO exceptions and not for MonadError, that'll be somewhere else

tryRead ∷ HasCallStack => String → IO (Either SomeException String)
tryRead = try . readFile

sampleIO :: HasCallStack => IO ()
sampleIO = throw $ userError "Bob"

failer :: HasCallStack => IO String
failer = fail "Bob"

tryer :: IO (Either SomeException String)
tryer = try failer

data DanException = DanException deriving (Show, Exception)

sampleHandler :: SomeException -> IO ()
sampleHandler (SomeException ex) = putStrLn $ "Caught error: (" <> displayException ex <> ")"

danHandler :: DanException -> IO ()
danHandler d@DanException = putStrLn $ "Caught DanException: " <> displayException d

main ∷ IO ()
main = do
    tryRead "bob" >>= print
    writeFile "Jim" "Contents"
    tryRead "Jim" >>= print
    tryer >>= print
    sampleIO `catch` danHandler `catch` sampleHandler
    throw DanException `catch` danHandler `catch` sampleHandler
    throw (userError "Bob again") `catch` danHandler `catch` sampleHandler
    catch @DanException (throw DanException) danHandler
    catch @SomeException (throw $ userError "Bob again again") sampleHandler