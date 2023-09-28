-- import Data.Maybe
import SafeDiv

main ∷ IO ()
-- print (saveDiv 2 11)
main = print (safeDiv (2 :: Double) (11 :: Double) :: Maybe Double)
