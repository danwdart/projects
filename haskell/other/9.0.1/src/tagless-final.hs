{-# LANGUAGE UnicodeSyntax #-}
{-}
import Control.Monad.IO.Class
import "mtl" Control.Monad.Reader
import "mtl" Control.Monad.Writer
import "mtl" Control.Monad.State
import "mtl" Control.Monad.RWS
import Data.String
import qualified Data.Text as T
import Data.Text (Text)

type AppRead = String
type AppState = Int
type AppWriter = [String]
type AppMonad = IO
type AppReturn = Char

default (Text)

class MonadConsole a where
    puts :: IsString s => s -> a ()
    gets :: IsString s => a s

instance MonadConsole IO where
    puts s = putStrLn (read . show $ s)
    gets = fromString <$> getLine

class MonadFile a where
    writef :: IsString s => FilePath -> s -> a ()
    readf :: IsString s => FilePath -> a s

instance MonadFile IO where
    writef f s = writeFile f s
    readf f = fromString <$> readFile f

newtype Fake a = Fake {
    unF :: a
} deriving (Functor)

instance Applicative Fake where
    pure = Fake
    Fake a <*> Fake b = Fake (a b)

instance Monad Fake where
    pure = Fake
    Fake a >>= f = f a

newtype AppM a = AppM {
    unApp :: RWST AppRead AppWriter AppState AppMonad a
} deriving (
    Functor,
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
-}

main ∷ IO ()
main = pure ()
