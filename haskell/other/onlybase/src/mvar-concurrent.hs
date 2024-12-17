module Main (main) where

import Control.Concurrent
-- import Control.Concurrent.Async
-- import Control.Concurrent.MVar

-- Who calculates? How do we tell really?

calcThunk ∷ Int → Int → MVar Int → IO ()
calcThunk a b mVar = do
    threadId <- myThreadId
    putStrLn $ "Hello from " <> show threadId
    
    putMVar mVar $ a + b

calcSelf ∷ Int → Int → MVar Int → IO ()
calcSelf a b mVar = do
    threadId <- myThreadId
    putStrLn $ "Hello from " <> show threadId
    
    putMVar mVar $! a + b

main ∷ IO ()
main = do
    threadId <- myThreadId
    putStrLn $ "Hello from " <> show threadId

    mVar <- newEmptyMVar

    threadId1 <- forkIO $ calcThunk 1 2 mVar
    result1 <- takeMVar mVar
    print (threadId1, result1)

    threadId2 <- forkIO $ calcSelf 1 2 mVar
    result2 <- takeMVar mVar
    print (threadId2, result2)
