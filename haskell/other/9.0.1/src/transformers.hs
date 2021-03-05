{-# LANGUAGE UnicodeSyntax #-}
import           Control.Monad.Trans.Writer.Lazy
-- import Control.Monad.Trans.State.Lazy
-- import Control.Monad.Trans.Maybe

myT ∷ String → WriterT [String] Maybe String
myT start = WriterT (Just (start, []))

myTResult ∷ Maybe (String, [String])
myTResult = runWriterT $ do
    x <- myT "Hi"
    tell ["His name was " <> x]
    tell ["It was indeed " <> x]
    pure $ "My name is " <> x

myTFirst ∷ Maybe String
myTFirst = fmap fst myTResult

myTLog ∷ Maybe [String]
myTLog = fmap snd myTResult

main ∷ IO ()
main = do
    print myTFirst
    print myTLog
