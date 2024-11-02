{-# OPTIONS_GHC -Wno-unused-top-binds #-}

main :: IO ()
main = pure ()

class Matrix n a where
    size :: a -> (n, n)
    getEntry :: a -> a -> n -> a

-- class IndexedMatrix i n a where
--     sizeIndexed :: a -> (i, i) -- why error???
--     getEntryIndexed :: i -> i -> n -> a


{-}
newtype Matrix a = Matrix [[a]]

instance Num (Matrix a) where
    Matrix _ + Matrix _ = undefined
    Matrix _ * Matrix _ = undefined
    abs (Matrix _) = undefined
    signum (Matrix _) = undefined
    fromInteger _ = undefined
    negate (Matrix _) = undefined
-}