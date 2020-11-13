main :: IO ()
-- where is value before, a kind of private state
main = print $ a ++ b where
    a = "a"
    b = "b"

-- let-in is value after, in the same way
foo =
    let b = 2
    in b + 2;