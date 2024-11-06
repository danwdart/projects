{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-safe #-}

module Main where

import Control.Monad.Reader
import Control.Monad.RWS
import Data.IORef

data AppState = AppState {
    anInt :: Int,
    aString :: String
} deriving (Eq, Show)

newtype AppWriter = AppWriter {
    unAppWriter :: [String]
}
    deriving stock (Eq, Show)
    deriving newtype (Semigroup, Monoid)

data AppEnv = AppEnv {
    serverName :: String,
    port :: Int
}

data RTEnv = RTEnv {
    appEnv :: AppEnv,
    appState :: IORef AppState,
    appWriter :: IORef AppWriter
}

newtype AppRTM a = AppRTM {
    runAppRTM :: ReaderT RTEnv IO a
} deriving newtype (Functor, Applicative, Monad)

newtype AppRWSTM a = AppRWSTM {
    runAppRWSTM :: RWST AppEnv AppWriter AppState IO a
} deriving newtype (
    Functor,
    Applicative,
    Monad,
    MonadReader AppEnv,
    MonadWriter AppWriter,
    MonadState AppState,
    MonadIO
    )

-- Crazy external library thing!


app :: (MonadReader AppEnv m, MonadWriter AppWriter m, MonadState AppState m, MonadIO m) => m String
app = do
    port' <- asks port
    serverName' <- asks serverName
    modify (\x -> x { anInt =  1 })
    modify (\x -> x { aString =  "Hi" })
    s <- gets aString
    tell $ AppWriter [serverName', "Awesome.", s, "Awesome again.", show port']
    liftIO . putStrLn $ "Hello"
    pure "yea"

main :: IO ()
main = do
    let env = AppEnv { serverName = "SN", port = 40000 }
    let initialState = AppState { anInt = 1, aString = "s" }
    (ret, w, s) <- runRWST (runAppRWSTM app) env initialState
    print (ret, w, s)

{-}
    stateRef <- newIORef initialState
    writerRef <- newIORef $ AppWriter []
    let rtEnv = RTEnv {
        appEnv = env,
        appState = stateRef,
        appWriter = writerRef
    }

    readResult <- runReaderT (runAppRTM app) rtEnv
    print readResult

-}