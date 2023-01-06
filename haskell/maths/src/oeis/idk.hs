indexed ∷ [Integer] → [(Integer, Integer)]
indexed = zip [0..] -- this with 0 and with 1 works

idk ∷ [Integer] → [Integer]
idk xs = sum (uncurry (+) <$> indexed xs) : xs

answer ∷ Integer → [Integer]
answer n = iterate idk [1] !! fromIntegral n

main ∷ IO ()
main = print . reverse . answer $ 10
