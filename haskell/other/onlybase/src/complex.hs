import           Data.Complex

complexNums ∷ [Complex Double]
complexNums = [
    (0 :+ 1) * (0 :+ 1),
    cis 1.0,
    conjugate (0 :+ 1),
    mkPolar 1.0 1.0]


realNums ∷ [Double]
realNums = [
    realPart (1 :+ 1),
    imagPart (0 :+ 1),
    magnitude (1 :+ 1),
    phase (1 :+ (-1))]

tuples ∷ [(Double, Double)]
tuples = [
    polar (1 :+ 2)]

allOfThem ∷ ([Complex Double], [Double], [(Double, Double)])
allOfThem = (complexNums, realNums, tuples)

main ∷ IO ()
main = print allOfThem
