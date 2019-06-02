import Control.Concurrent
import Control.Concurrent.Async

task :: IO ()
task = threadDelay 1000000

main :: IO ()
main = async task >>= wait

main2 :: IO ()
main2 = withAsync task wait

main3 :: IO ((), ())
main3 = concurrently task task

task2 :: IO String
task2 = return "Hi!"

main4 :: IO ()
main4 = mapConcurrently_ putStrLn ["Hi", "Hi2"]

main5 :: IO ()
main5 = forConcurrently_ ["1","2","3"] putStrLn

main6 :: IO ()
main6 = replicateConcurrently_ 16 (putStrLn "Hi")
