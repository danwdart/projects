{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

-- Let's make our own event loop
-- import Control.Concurrent.Event ( Event )
import           Control.Concurrent
import           Control.Concurrent.Async.Lifted
import qualified Control.Concurrent.Event        as Event

main ∷ IO ()
main = do
    myNewEvent <- Event.new
    concurrently_ (
        do
            threadDelay 5000000
            Event.set myNewEvent) (
        do
            Event.wait myNewEvent
            putStrLn "Set!" )

{-
main2 :: IO ((),())
main2 = runConcurrently $ (,) <$>
        Concurrently (threadDelay 5000000)
        <*>
        Concurrently (putStrLn "Hi")
-}
