module Main (main) where

-- import Control.Monad
import List
import StringToInteger
import           System.Environment

-- args = pure ["Foo"] :: IO [String]

foo ∷ IO [String] → IO (Maybe String)
foo = fmap (maybeIndex 0)

innerFmap ∷ (Functor f1, Functor f2) ⇒ (a → b) → f1 (f2 a) → f1 (f2 b)
innerFmap = fmap fmap fmap

bar ∷ IO (Maybe String) → IO (Maybe Integer)
bar = innerFmap stringToInteger

main ∷ IO ()
main = bar (foo getArgs) >>= print
