{-# LANGUAGE PackageImports #-}

import Control.Monad.IO.Class
import "mtl" Control.Monad.RWS

type AppRead = String
type AppState = Int
type AppWriter = [String]
type AppMonad = IO
type AppReturn = Char

stuff ∷ RWS AppRead AppWriter AppState AppReturn
stuff = do
    tell ["hi"]
    put 2
    asks (!! 0)

stuff2 ∷ RWST AppRead AppWriter AppState AppMonad AppReturn
stuff2 = do
    tell ["hey"]
    liftIO . print $ "AAA"
    put 2
    asks (!! 0)

main ∷ IO ()
main = do
    print $ runRWS stuff "aeiou" 1
    print =<< runRWST stuff2 "aeiou" 1
