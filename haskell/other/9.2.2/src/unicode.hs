-- Just stolen from reader

import Control.Monad.Unicode
import Data.Function.Unicode
import Data.List.Unicode
import Data.Monoid.Unicode
import Numeric.Natural.Unicode
import           Control.Monad.Reader

intToIntReader ∷ Reader ℕ ℕ
intToIntReader = reader succ

stringToStringReader ∷ Reader String String
stringToStringReader = reader (⊕ "Bob")

stringToIntReaderComplex ∷ Reader String Int
stringToIntReaderComplex = local (⊕ "Bobby") $ asks length

rtSimple ∷ ReaderT String IO ()
rtSimple = ask ≫= liftIO ∘ putStrLn

rt ∷ ReaderT String IO ()
rt = ReaderT $ liftIO ∘ putStrLn
    
rWithLocal ∷ Reader String String
rWithLocal = local (⧺ "Jim") stringToStringReader

main ∷ IO ()
main = do
    print $ runReader intToIntReader 11
    print $ runReader stringToStringReader "Bob"
    print $ runReader rWithLocal "Ted"
    print $ runReader stringToIntReaderComplex "Bobby"
    runReaderT rtSimple "Bob"
    runReaderT rt "Bob"
