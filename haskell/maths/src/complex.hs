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

-- these can be not only numbers, guess it's just like tuple in that case, but both arguments are dealt with as if fmap is bimapBoth
wat ∷ Complex String
wat = "why" :+ "wat"

-- you can even monadically compute these
computationable :: Complex String
computationable = do
    a <- wat
    pure $ a <> "?"

allOfThem ∷ ([Complex Double], [Double], [(Double, Double)], [Complex String])
allOfThem = (complexNums, realNums, tuples, [wat, computationable])


main ∷ IO ()
main = print allOfThem
