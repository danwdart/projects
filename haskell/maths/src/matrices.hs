main :: IO ()
main = pure ()

newtype Matrix a = Matrix [[a]]

instance Num (Matrix a) where
    Matrix _ + Matrix _ = undefined
    Matrix _ * Matrix _ = undefined
    abs (Matrix _) = undefined
    signum (Matrix _) = undefined
    fromInteger _ = undefined
    negate (Matrix _) = undefined