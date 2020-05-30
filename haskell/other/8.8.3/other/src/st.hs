{-# LANGUAGE UnicodeSyntax #-}
-- import Control.Monad
import           Control.Monad.ST
import           Data.STRef

a ∷ ST s Int
a = newSTRef 0 >>= (\x -> modifySTRef x (+1) >> modifySTRef x (*2) >> writeSTRef x 200 >> readSTRef x)

b ∷ ST s Int
b = do
    x <- newSTRef 0
    modifySTRef x (+1)
    modifySTRef x (*2)
    writeSTRef x 200
    readSTRef x

main ∷ IO ()
main = do
    print $ runST a
    print $ runST b
