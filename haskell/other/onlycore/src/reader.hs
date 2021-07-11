{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}
import           Control.Monad.Reader

-- Reader a b is a -> b

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
    _ <- ask
    _ <- asks (++"Bob")
    liftIO . putStrLn

rWithLocal ∷ Reader String String
rWithLocal = local (++"Jim") stringToStringReader


s2s1 ∷ String → String
s2s1 = ("Hello!! " ++)

-- This needs some DI.
s2s2 ∷ String → String
s2s2 = ("Hi, my name is " ++) . (++ "!")

s2s3 ∷ String → String
s2s3 = s2s1 . s2s2

-- It could be done with two... but there's no point...
r1 ∷ Reader String String
r1 = asks s2s1

r2 ∷ Reader String String
r2 = asks s2s2

r3 ∷ Reader String String
r3 = do
    a <- ask
    let b = runReader r2 a
    pure $ runReader r1 b

mergeReaders ∷ Reader a b → Reader b c → Reader a c
mergeReaders a b = asks $ runReader b . runReader a

-- TODO Kleisli & Category

r3alt ∷ Reader String String
r3alt = mergeReaders r2 r1

main ∷ IO ()
main = do
    print $ runReader intToIntReader 11
    print $ runReader stringToStringReader "Bob"
    print $ runReader rWithLocal "Ted"
    print $ runReader stringToIntReaderComplex "Bobby"
    runReaderT rtSimple "Bob"
    runReaderT rt "Bob"
    putStrLn . s2s1 . s2s2 $ "Bob"
    putStrLn . runReader r1 $ runReader r2 "Bob"
    putStrLn . s2s1 $ runReader r2 "Bob"
    putStrLn $ runReader r3 "Bob"
    putStrLn $ runReader r3alt "Bob"
    -- putStrLn $ runReader readerRec reader1
