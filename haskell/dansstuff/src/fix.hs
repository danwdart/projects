import Control.Monad.Fix

main :: IO ()
main = do
    print $ take 24 $ fix (1:)
    print $ take 24 $ fix ("a"++)