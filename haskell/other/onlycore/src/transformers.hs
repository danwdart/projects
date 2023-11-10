module Main (main) where

import Control.Monad.IO.Class
import Control.Monad.Trans.Writer.Lazy
-- import Control.Monad.Trans.State.Lazy
-- import Control.Monad.Trans.Maybe

myT ∷ String → WriterT [String] Maybe String
myT start = WriterT (Just (start, []))

myT2 ∷ WriterT [String] Maybe String
myT2 = do
    x <- myT "Hi"
    let y = pure "i" :: [String]
    tell y
    tell ["His name was " <> x]
    tell ["It was indeed " <> x]
    pure $ "My name is " <> x

myTResult ∷ Maybe (String, [String])
myTResult = runWriterT myT2

myTFirst ∷ Maybe String
myTFirst = fmap fst myTResult

myTLog ∷ Maybe [String]
myTLog = fmap snd myTResult

newExample ∷ WriterT [String] IO String
newExample = do
    tell ["Hi"]
    -- This won't return the original tell... so what's the use?
    (a, _) <- listen (liftIO getLine)
    tell [a]
    -- pass (lift reverse)
    -- censor _
    -- This will keep the original tell.
    pure "OK"

main ∷ IO ()
main = do
    print myTFirst
    print myTLog
    runWriterT newExample >>= print
