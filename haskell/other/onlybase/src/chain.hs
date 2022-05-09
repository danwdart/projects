chain ∷ Integer → [Integer]
chain 1 = [1]
chain n
    | even n =  n:chain (n `div` 2)
    | odd n  =  n:chain (n*3 + 1)
chain _ = undefined -- wut

main ∷ IO ()
main = print $ chain 89
