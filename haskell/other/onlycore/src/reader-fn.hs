{-# LANGUAGE FlexibleContexts #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}
-- Reader for function arrow.

import Control.Monad.Reader

addEx :: String -> String
addEx = (<> "!")

addExR :: String -> String
addExR = asks addEx

-- (-> a) is an instance of MonadReader a
addExRR :: MonadReader String m => m String
addExRR = asks addEx

-- Too much duplication
g :: String -> String
g k = g' <> " " <> g' where
    g' = k <> "!!!"

action :: String -> IO ()
action str = putStrLn "Ready." >> f >> f where
    f = putStrLn str

-- Let's pass through config implicitly.
gR :: MonadReader String m => m String
gR = do
    g' <- ask
    let k = g' <> "!!!"
    pure $ k <> " " <> k

-- We don't have to refer to the parameter.
actionR :: (MonadReader String m, MonadIO m) => m ()
actionR = liftIO (putStrLn "Ready.")
    >> ask
    >>= liftIO . putStrLn
    >> ask
    >>= liftIO . putStrLn

main :: IO ()
main = do
    putStrLn $ addEx "Ted"
    putStrLn $ addExR "Jim"

    putStrLn $ addExRR "Bob"
    putStrLn $ runReader addExRR "Bobn't"

    putStrLn $ g "Bob"
    putStrLn $ runReader gR "Bob"

    action "Ta-da!"
    runReaderT actionR "Ta-da!"