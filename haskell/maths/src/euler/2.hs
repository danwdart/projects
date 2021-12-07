{-# LANGUAGE UnicodeSyntax #-}
result ∷ Int
result = sum . filter even $ last (takeWhile (all (<4000000)) $ iterate sumIter [2,1])
    where
        sumIter (a:b:xs) = (a + b):(a:b:xs)
        sumIter _ = []

main ∷ IO ()
main = print result
