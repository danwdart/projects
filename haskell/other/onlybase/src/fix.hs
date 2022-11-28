{-# LANGUAGE RecursiveDo #-}

import           Control.Monad.Fix

-- >>> fixRevIO (\a -> putStrLn "Hi" >> pure 2) (\b -> putStrLn "Hey" >> pure 1)

amb :: Int -> IO String
amb a = do
    putStrLn "Hi"
    pure "yo"

bma :: String -> IO Int
bma b = do
    putStrLn "Hey"
    pure 2


fixRevIO :: (a -> IO b) -> (b -> IO a) -> IO (a, b)
fixRevIO amb' bma' = mdo
    a <- bma' b
    b <- amb' a
    pure (a, b)

main ∷ IO ()
main = do
    print . take 24 $ fix ((1 :: Integer):)
    print . take 24 $ fix ("a"++)
    (a, b) <- fixRevIO amb bma
    print (a, b)
