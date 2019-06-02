import Control.Concurrent
import Control.Concurrent.Async
import Control.Concurrent.MVar

main1 = newEmptyMVar >>= (\x -> putMVar x 1 >> takeMVar x) >>= print
main2 = do
    x <- newEmptyMVar
    putMVar x 1
    y <- takeMVar x
    print y

main = do
    main1
    main2