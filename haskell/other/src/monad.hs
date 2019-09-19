{- TODO: Deriving -}

newtype Bob a = Bob a deriving (Show)

instance Functor Bob where
    fmap f (Bob x) = Bob (f x)

instance Applicative Bob where
    pure = Bob
    (Bob f) <*> (Bob x) = Bob (f x)

instance Monad Bob where
    (Bob x) >>= f = f x

main :: IO ()
main = print $ Bob (2 :: Int) >>= return . (*2)