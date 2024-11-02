{-# LANGUAGE PackageImports, Unsafe #-}
{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-safe -Wno-unsafe #-}

module Main (main) where

import Control.Monad.IO.Class
import Control.Monad.Fix
import "mtl" Control.Monad.Reader
import "mtl" Control.Monad.Writer
import "mtl" Control.Monad.State
import "mtl" Control.Monad.RWS
import Data.String
-- import Data.Text qualified as T
-- import Data.Text (Text)

type AppRead = String
type AppState = Int
type AppWriter = [String]
type AppMonad = IO
type AppReturn = Char

-- default (Text)

class MonadConsole a where
    puts :: Show s => s -> a ()
    gets :: IsString s => a s

instance MonadConsole IO where
    puts s = putStrLn (read . show $ s)
    gets = fromString <$> getLine

class MonadFile a where
    writef :: Show s => FilePath -> s -> a ()
    readf :: IsString s => FilePath -> a s

instance MonadFile IO where
    writef f s = writeFile f (show s)
    readf f = fromString <$> readFile f

newtype Fake a = Fake {
    unF :: a
} deriving stock (Functor)

instance Applicative Fake where
    pure = Fake
    Fake a <*> Fake b = Fake (a b)

instance Monad Fake where
    Fake a >>= f = f a

newtype AppM a = AppM {
    unApp :: RWST AppRead AppWriter AppState AppMonad a
} deriving stock (
    Functor
    ) deriving newtype (
    Applicative,
    Monad,
    MonadIO,
    MonadFix,
    MonadFail,
    MonadReader AppRead,
    MonadWriter AppWriter,
    MonadState AppState
    )

runAppM :: AppM a -> AppRead -> AppState -> AppMonad (a, AppState, AppWriter)
runAppM = runRWST . unApp

stuff3 :: AppM AppReturn
stuff3 = do
    tell ["yo"]
    liftIO . print $ "Fool!"
    put 2
    asks (!! 0)

main :: IO ()
main = do
    print =<< runAppM stuff3 "aeiou" 1