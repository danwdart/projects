{-# LANGUAGE UnicodeSyntax #-}
import Control.Monad.Reader

-- Reader a b is a → b

intToIntReader ∷ Reader Int Int
intToIntReader = reader (+1)

stringToStringReader ∷ Reader String String
stringToStringReader = reader (++"Bob")

stringToIntReaderComplex ∷ Reader String Int
stringToIntReaderComplex = local (++"Bobby") $ asks length

rtSimple ∷ ReaderT String IO ()
rtSimple = ask >>= liftIO . putStrLn

rt ∷ ReaderT String IO ()
rt = ReaderT $ do
    x ← ask
    y ← asks (++"Bob")
    liftIO . putStrLn 

rWithLocal ∷ Reader String String
rWithLocal = local (++"Jim") stringToStringReader

main ∷ IO ()
main = do
    print $ runReader intToIntReader 11
    print $ runReader stringToStringReader "Bob"
    print $ runReader rWithLocal "Ted"
    print $ runReader stringToIntReaderComplex "Bobby"
    runReaderT rtSimple "Bob"
    runReaderT rt "Bob"