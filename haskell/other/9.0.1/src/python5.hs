{-# LANGUAGE UnicodeSyntax #-}
import           Control.Monad
import           Control.Monad.ST
import           Data.Array.ST
import           Data.Foldable

bubbleSort ∷ STArray s Int Int → ST s ()
bubbleSort xs = do
    (low, high) <- getBounds xs
    for_ [low .. high - 1] $ \i ->
        for_ [i + 1 .. high] $ \j -> do
            x <- readArray xs i
            y <- readArray xs j
            when (x > y) $ do
                writeArray xs i y
                writeArray xs j x

runSort ∷ [Int] → [Int]
runSort xs = runST $ do
    a <- newListArray (0, length xs - 1) xs
    bubbleSort a
    getElems a

main ∷ IO ()
main = print $ runSort [1,6,2,6,4,2]
