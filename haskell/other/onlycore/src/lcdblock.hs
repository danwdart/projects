import LCDBlock

main ∷ IO ()
main = mapM_ printN ([1..127] :: [Int])
