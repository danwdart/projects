{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE UnicodeSyntax        #-}
{-# LANGUAGE Unsafe               #-}
{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-safe -Wno-unsafe #-}

-- As of 2024-11-09, stylish-haskell doesn't understand 9.10 / GHC2024. Hence DerivingStrategies here instead.

module Main (main) where

import Control.Monad.Fix
import Control.Monad.IO.Class
import Control.Monad.Reader
import Control.Monad.RWS
-- import Data.String
-- import Data.Text qualified as T
-- import Data.Text (Text)

type AppRead = String
type AppState = Int
type AppWriter = [String]
type AppMonad = IO
type AppReturn = Char

-- default (Text)

-- monoid, semigroup too anyway
-- StringLike from https://hackage.haskell.org/package/ListLike ig
class StringType s where
    toString :: s → String
    fromString :: String → s

instance StringType String where
    toString = id
    fromString = id

class MonadConsole m where
    putStrC :: StringType s ⇒ s → m ()
    getStrC :: StringType s ⇒ m s

-- These only make sense in event-loop programs (potentially with threads)
-- Should we be trying to emulate their behaviour?
makeNoInputIntoAsync ∷ m b → (b → m ()) → m () -- maybe?
makeNoInputIntoAsync = undefined

makeIntoAsync ∷ (a → m b) → (a → (b → m ())) -- or something?
makeIntoAsync = undefined

class MonadAsyncConsole m where
    putStrCAsync :: StringType s ⇒ s → m () -- at some point
    putStrCAsyncWithConfirm :: StringType s ⇒ s → m () → m () -- possibly???
    handleGetStrCAsync :: StringType s ⇒ (s → m ()) → m () -- I think? or is that m s -> m ()?

instance MonadIO m ⇒ MonadConsole m where
    putStrC = liftIO . putStrLn . toString
    getStrC = fromString <$> liftIO getLine

class MonadFile m where
    writef :: StringType s ⇒ FilePath → s → m ()
    readf :: StringType s ⇒ FilePath → m s

class MonadAsyncFile m where
    writefAsync :: StringType s ⇒ FilePath → s → m ()
    writefAsyncWithConfirm :: StringType s ⇒ FilePath → s → m () → m ()
    readfAsync :: StringType s ⇒ FilePath → (s → m ()) → m ()

instance MonadIO m ⇒ MonadFile m where
    writef f s = liftIO $ writeFile f (toString s)
    readf f = fromString <$> liftIO (readFile f)

-- a type that does nothing special
newtype NullF a = NullF {
    unNullF :: a
} deriving stock (Functor)

instance Applicative NullF where
    pure = NullF
    NullF a <*> NullF b = NullF (a b)

instance Monad NullF where
    NullF a >>= f = f a

newtype NoConsole m a = NoConsole {
    runNoConsole :: m a
} deriving newtype (Functor, Applicative, Monad) -- , MonadLift, MonadTrans

instance (Applicative m) ⇒ MonadConsole (NoConsole m) where
    putStrC _ = pure ()
    getStrC = pure (fromString "")

-- make this a state monad / writer / inverse writer such as "get the next thing" is that a thing
-- newtype FakeConsole m a = FakeConsole {

-- }

-- a type that logs what you give it
{-}
data FunkyLoggingThings a = {
    getA :: a,
    fakeFiles :: Map FileName String,
    fakeConsole :: [String] -- guess we can use the reader for this!
}
-}

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

runAppM ∷ AppM a → AppRead → AppState → AppMonad (a, AppState, AppWriter)
runAppM = runRWST . unApp

stuff3 ∷ AppM AppReturn
stuff3 = do
    tell ["yo"]
    putStrC "Fool!"
    put 2
    asks (!! 0)

main ∷ IO ()
main = do
    print =<< runAppM stuff3 "aeiou" 1
