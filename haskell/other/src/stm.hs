import Control.Monad.STM
import Control.Concurrent.STM.TVar

main1 = atomically (newTVar 1 >>= (\t -> writeTVar t 1 >> readTVar t)) >>= print

tv2 = do
    x <- newTVar 1
    writeTVar x 1
    readTVar x

main2 = atomically tv2 >>= print

main = do
    main1
    main2
