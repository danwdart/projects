import Control.Concurrent
import Control.Concurrent.Async

slow :: Int -> IO Int
slow x = threadDelay 100000 >> pure x

main :: IO ()
main = do
    putStrLn "Serial"
    numbers <- mapM slow [1..10]
    print numbers
    putStrLn "Concurrent"
    numbers2 <- mapConcurrently slow [1..10]
    print numbers2