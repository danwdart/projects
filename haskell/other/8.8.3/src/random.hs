{-# LANGUAGE UnicodeSyntax #-}
import           Control.Monad
import           System.Random

aa ∷ IO [Int]
aa = replicateM 3 $ randomRIO (0, 255)

main ∷ IO ()
main = do
    a <- aa
    print a
    -- replicateM 20 $ randomRIO ('a','z')
