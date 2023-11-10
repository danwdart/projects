module Main (main) where

-- where is value before, a kind of private state
wherey ∷ String
wherey = a <> b where
    a = "a"
    b = "b"

-- let-in is value after, in the same way
letin ∷ Int
letin =
    let b = 2 :: Int
    in b + 2

main ∷ IO ()
main = do
    print wherey
    print letin

