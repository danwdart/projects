{-# LANGUAGE UnicodeSyntax #-}
module Main (main) where

-- import Control.Monad
import           Data.Char
import           Numeric
import           System.Environment

maybeIndex ∷ Int → [a] → Maybe a
maybeIndex index xs = if null xs then Nothing else Just $ xs !! index

stringToInteger ∷ String → Integer
stringToInteger string = fst $ head (readHex $ concatMap ((`showHex` "") . ord) (filter notSpaces string)) where
    notSpaces = (/=' ')

-- args = pure ["Foo"] :: IO [String]

foo ∷ IO [String] → IO (Maybe String)
foo = fmap (maybeIndex 0)

innerFmap ∷ (Functor f1, Functor f2) ⇒ (a → b) → f1 (f2 a) → f1 (f2 b)
innerFmap = fmap fmap fmap

bar ∷ IO (Maybe String) → IO (Maybe Integer)
bar = innerFmap stringToInteger

main ∷ IO ()
main = bar (foo getArgs) >>= print
