{-# LANGUAGE UnicodeSyntax #-}
import           Data.IORef

main1 ∷ IO ()
main1 = newIORef (0 :: Int) >>= (\r -> modifyIORef r (+2) >> readIORef r >>= print)

main2 ∷ IO ()
main2 = do
    r <- newIORef "Hi "
    modifyIORef r (++"Bob")
    x <- readIORef r
    putStrLn x

main ∷ IO ()
main = do
    main1
    main2
