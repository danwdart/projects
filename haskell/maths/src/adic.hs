-- n-adic numbers (in a way)

import GHC.Natural (powModNatural)

main ∷ IO ()
main = do
    mapM_ print $ [(x, powModNatural 2 (100000000000000 * x) 1000000000000000) | x <- [1..100]]
    let a ∷ Integer
        a = fromIntegral $ powModNatural 2 10000000000000000 1000000000000000
    print $ mod (a * a) 1000000000000000 == a
