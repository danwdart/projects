module Main (main) where

import Numeric.ProjectEuler.Solution1 as S1
import Numeric.ProjectEuler.Solution2 as S2
import Numeric.ProjectEuler.Solution3 as S3
import Numeric.ProjectEuler.Solution4 as S4
import Numeric.ProjectEuler.Solution5 as S5
import Numeric.ProjectEuler.Solution6 as S6
import Text.Printf

explain ∷ Integer → Integer → String
explain = printf "The solution to Project Euler problem %lld is %lld"

-- @TODO args
main ∷ IO ()
main = mapM_ (putStrLn . uncurry explain) $ zip [1..] [
    S1.solution,
    S2.solution,
    S3.solution,
    S4.solution,
    S5.solution,
    S6.solution
    ]
