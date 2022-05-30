-- Procedural generation
import           Control.Monad
import           System.Random

main ∷ IO ()
main = do
    randomHills <- replicateM 25 $ randomRIO (-1,1) :: IO [Int]
    print $ scanl1 (+) randomHills
