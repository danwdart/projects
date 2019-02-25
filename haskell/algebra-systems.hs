by f n m = show n ++ " with " ++ show m ++ " = " ++ show (f m n)

dor f r = map (flip (map . f) r) r

result = dor (by max) [0..10]

main = print result