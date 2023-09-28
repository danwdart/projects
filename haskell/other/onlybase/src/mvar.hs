import Control.Concurrent
-- import Control.Concurrent.Async
-- import Control.Concurrent.MVar

main1 ∷ IO ()
main1 = newEmptyMVar >>= (\x -> putMVar x (1 :: Int) >> takeMVar x) >>= print

main2 ∷ IO ()
main2 = do
    x <- newEmptyMVar
    putMVar x (1 :: Int)
    y <- takeMVar x
    print y

main ∷ IO ()
main = do
    main1
    main2
