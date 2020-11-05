{-# LANGUAGE UnicodeSyntax #-}
import           Control.Concurrent
import           Control.Concurrent.Async

task ∷ IO ()
task = threadDelay 1000000

main ∷ IO ()
main = do
    a <- async task
    wait a
    withAsync task wait
    concurrently_ task task
    mapConcurrently_ putStrLn ["Hi", "Hi2"]
    forConcurrently_ ["1","2","3"] putStrLn
    replicateConcurrently_ 16 (putStrLn "Hi")
