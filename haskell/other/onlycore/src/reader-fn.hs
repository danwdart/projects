{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main (main) where

-- Reader for function arrow.

import Control.Monad.Reader
import Data.Word
import Text.Printf

addEx ∷ String → String
addEx = (<> "!")

addExR ∷ String → String
addExR = asks addEx

-- (-> a) is an instance of MonadReader a
addExRR ∷ MonadReader String m ⇒ m String
addExRR = asks addEx

-- Too much duplication
g ∷ String → String
g k = g' <> " " <> g' where
    g' = k <> "!!!"

action ∷ String → IO ()
action str = putStrLn "Ready." >> f >> f where
    f = putStrLn str

-- Let's pass through config implicitly.
gR ∷ MonadReader String m ⇒ m String
gR = do
    g' <- ask
    let k = g' <> "!!!"
    pure $ k <> " " <> k

-- We don't have to refer to the parameter.
actionR ∷ (MonadReader String m, MonadIO m) ⇒ m ()
actionR = liftIO (putStrLn "Ready.")
    >> ask
    >>= liftIO . putStrLn
    >> ask
    >>= liftIO . putStrLn

-- How about some nonsense?
data Config = Config {
    server   :: String,
    port     :: Word16,
    username :: String,
    password :: String
}

instance Show Config where
    show Config { server = server, port = port, username = username } =
        printf "Config { server = %s, port = %d, username = %s, password = <redacted> }" server port username

config ∷ Config
config = Config {
    server = "dabdart.co.uk",
    port = 443,
    username = "dan",
    password = "What? I'm not going to tell you! Look it up from the environment!"
}

-- urgh!
doSomethingVeryImportant ∷ Config → IO ()
doSomethingVeryImportant config' = do
    putStrLn "This is very important"
    performTaskIndividually config'
    performAnotherTask config'

performTaskIndividually ∷ Config → IO ()
performTaskIndividually config' = mapM_ (performSubtaskIndividually config') [1..5]

performSubtaskIndividually ∷ Config → Int → IO ()
performSubtaskIndividually config' time = do
    print time
    print $ "Connecting fakily to the server " <> server config'

performAnotherTask ∷ Config → IO ()
performAnotherTask config' = do
    putStrLn "I think I need a little DEBUG OPERATIONS!"
    print config'

-- Now properly using the reader arrow functor
doSomethingVeryImportantF ∷ Config → IO ()
doSomethingVeryImportantF config' = do -- todo without?
    putStrLn "This is very important"
    performTaskIndividuallyF config'
    performAnotherTaskF config'

performTaskIndividuallyF ∷ Config → IO ()
performTaskIndividuallyF config' = mapM_ (`performSubtaskIndividuallyF` config') [1..5] -- todo without?

performSubtaskIndividuallyF ∷ Int → Config → IO ()
performSubtaskIndividuallyF time config' = do
    print time
    print $ "Connecting fakily to the server" <> server config'

performAnotherTaskF ∷ Config → IO ()
performAnotherTaskF config' = do -- TODO without?
    putStrLn "I think I need a little DEBUG OPERATIONS!"
    print config'


-- Now properly in mtl style
doSomethingVeryImportantR ∷ (MonadReader Config m, MonadIO m) ⇒ m ()
doSomethingVeryImportantR = do
    liftIO . putStrLn $ "This is very important"
    performTaskIndividuallyR
    performAnotherTaskR

performTaskIndividuallyR ∷ (MonadReader Config m, MonadIO m) ⇒ m ()
performTaskIndividuallyR = mapM_ performSubtaskIndividuallyR [1..5]

performSubtaskIndividuallyR ∷ (MonadReader Config m, MonadIO m) ⇒ Int → m ()
performSubtaskIndividuallyR time = do
    server' <- asks server
    liftIO . print $ time
    liftIO . print $ "Connecting fakily to the server" <> server'

performAnotherTaskR ∷ (MonadReader Config m, MonadIO m) ⇒ m ()
performAnotherTaskR = do
    config' <- ask
    liftIO . putStrLn $ "I think I need a little DEBUG OPERATIONS!"
    liftIO . print $ config'


main ∷ IO ()
main = do
    putStrLn $ addEx "Ted"
    putStrLn $ addExR "Jim"

    putStrLn $ addExRR "Bob"
    putStrLn $ runReader addExRR "Bobn't"

    putStrLn $ g "Bob"
    putStrLn $ runReader gR "Bob"

    action "Ta-da!"
    runReaderT actionR "Ta-da!"

    putStrLn "Plain Action without Smartness"
    doSomethingVeryImportant config

    putStrLn "Reader function action arrow monad"
    doSomethingVeryImportantF config

    putStrLn "Reader function action mtl"
    runReaderT doSomethingVeryImportantR config
