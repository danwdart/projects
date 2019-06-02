import Data.IORef

main1 = newIORef 0 >>= (\r -> modifyIORef r (+2) >> readIORef r >>= print)

main2 = do
    r <- newIORef "Hi "
    modifyIORef r (++"Bob")
    x <- readIORef r
    putStrLn x

main = do
    main1
    main2