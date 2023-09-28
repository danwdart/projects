import Control.Concurrent.STM.TVar
import Control.Monad.STM

main1 ∷ IO ()
main1 = atomically (newTVar (1 :: Int) >>= (\t -> writeTVar t 1 >> readTVar t)) >>= print

tv2 ∷ STM Int
tv2 = do
    x <- newTVar (1 :: Int)
    writeTVar x 1
    readTVar x

main2 ∷ IO ()
main2 = atomically tv2 >>= print

main ∷ IO ()
main = do
    main1
    main2
