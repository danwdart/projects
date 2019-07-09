import Control.Monad
import System.Random

main :: IO ()
main = do
    print $ replicateM 3 $ randomRIO (0, 255)
    -- replicateM 20 $ randomRIO ('a','z')