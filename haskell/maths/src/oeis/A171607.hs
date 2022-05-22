import           Data.List
import           Data.Set


main ∷ IO ()
main = print values

values ∷ Set Integer
values = fromList $ sort [a * b ^ a | a <- [2..20], b <- [2..20]]
