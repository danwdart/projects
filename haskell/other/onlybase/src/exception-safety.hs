import           Control.Exception
import           Control.Monad.Fail
-- import System.IO
-- now there's a try and an exception monad

type IOStrEx = IO (Either SomeException String)

tryRead ∷ String → IOStrEx
tryRead = try.readFile

main ∷ IO ()
main = do
    tryRead "bob" >>= print
    writeFile "Jim" "Contents"
    tryRead "Jim" >>= print
    _ <- pure (try $ Control.Monad.Fail.fail "Bob" :: IOStrEx)
    pure ()
    -- userError "Bob"
