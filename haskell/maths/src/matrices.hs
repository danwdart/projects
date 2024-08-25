main :: IO ()
main = pure ()

newtype Matrix a = Matrix [[a]]

instance Num (Matrix a) where
    Matrix a + Matrix b = undefined
    Matrix a * Matrix b = undefined
    abs (Matrix a) = undefined
    signum (Matrix a) = undefined
    fromInteger a = Matrix [[a]]
    negate (Matrix a) = undefined