{-# LANGUAGE DeriveFunctor     #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE RankNTypes        #-}
{-# LANGUAGE UnicodeSyntax     #-}
{-# OPTIONS_GHC -Wwarn #-}

data IOF t a
  = Input (t → a)
  | Output t a
  | ReadFile t (t → a)
  | WriteFile t t a
  deriving Functor

data Free f a = Pure a | Free (f (Free f a)) deriving Functor

instance Functor f ⇒ Applicative (Free f) where
    pure = Pure
    Pure a <*> Pure b = Pure $ a b
    Pure a <*> Free f = Free $ fmap a <$> f
    Free f <*> b      = Free $ (<*> b) <$> f

instance Functor f ⇒ Monad (Free f) where
    Pure a >>= f = f a
    Free m >>= f = Free ((>>= f) <$> m)

liftF ∷ Functor f ⇒ f a → Free f a
liftF f = Free (fmap Pure f)

foldFree ∷ Monad m ⇒ (forall x . f x → m x) → Free f a → m a
foldFree _ (Pure a)  = pure a
foldFree f (Free as) = f as >>= foldFree f

type FreeIOF t = Free (IOF t)

readStrLnF ∷ FreeIOF String String
readStrLnF = liftF $ Input id

putStrLnF ∷ String → FreeIOF String ()
putStrLnF str = liftF $ Output str ()

readFileF ∷ String → FreeIOF String String
readFileF filename = liftF $ ReadFile filename id

writeFileF ∷ String → String → FreeIOF String ()
writeFileF filename contents = liftF $ WriteFile filename contents ()

program ∷ FreeIOF String ()
program = do
    putStrLnF "Please enter file to read."
    fileToRead <- readStrLnF
    putStrLnF "Please enter file to write."
    fileToWrite <- readStrLnF
    putStrLnF $ "Going to read from " <> fileToRead
    contents <- readFileF fileToRead
    putStrLnF contents
    putStrLnF $ "Going to write to " <> fileToWrite
    writeFileF fileToWrite contents
    putStrLnF "Done!"

interpret ∷ FreeIOF String () → IO ()
interpret = foldFree $ \case
    Input next                       -> next <$> getLine
    Output str next                  -> next <$ putStrLn str
    ReadFile filename next           -> next <$> readFile filename
    WriteFile filename contents next -> next <$ writeFile filename contents

mockFiles ∷ FreeIOF String () → IO ()
mockFiles = foldFree $ \case
    Input next             -> next <$> getLine
    Output str next        -> next <$ putStrLn str
    ReadFile filename next -> pure $ next filename
    WriteFile _ _ next     -> pure next

pretty ∷ String → FreeIOF String () → String
pretty _ (Pure _) = ""
pretty demoInput (Free f) = case f of
    Input next -> "Input (" <> demoInput <> ")\n" <> pretty demoInput (next demoInput)
    Output str next -> "Output: " <> str <> "\n" <> pretty demoInput next
    ReadFile filename next -> "Read file: " <> filename <> "\n" <> pretty demoInput (next demoInput)
    WriteFile filename contents next -> "Write file: " <> filename <> " with contents of length " <> show (length contents) <> "\n" <> pretty demoInput next

main ∷ IO ()
main = do
    putStrLn "Running this:"
    putStrLn $ pretty "Demo" program
    putStrLn "Fake version:"
    mockFiles program
    putStrLn "Real version:"
    interpret program

