import Data.Word

table ∷ [[Word8]]
table = (\x -> (x *) <$> [1..255]) <$> [1..255]

main ∷ IO ()
main = print table
