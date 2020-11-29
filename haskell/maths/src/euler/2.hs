{-# LANGUAGE UnicodeSyntax #-}
result ∷ Int
result = sum . filter even $ last (takeWhile (all (<4000000)) $ iterate (\(a:b:xs) -> (a + b):(a:b:xs)) [2,1])

main ∷ IO ()
main = print result
