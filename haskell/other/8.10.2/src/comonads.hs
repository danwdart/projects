{-# LANGUAGE DeriveFoldable  #-}
{-# LANGUAGE DeriveFunctor   #-}
{-# LANGUAGE UnicodeSyntax   #-}

import           Control.Comonad
import           Control.Comonad.Env
import           Control.Comonad.Store
import           Control.Comonad.Traced
import           Data.Foldable

data MyComonad a = MyComonad a deriving (Functor, Show)

instance Comonad MyComonad where
    extract (MyComonad a) = a
    duplicate = MyComonad

data MyComonad2 a = MyComonad2 a deriving (Functor, Show)

instance Comonad MyComonad2 where
    extract (MyComonad2 a) = a
    extend = (MyComonad2 .)

mc :: MyComonad Int
mc = MyComonad 1

data W2 p a = W2 p a deriving (Show)

instance Functor (W2 p) where
    fmap f (W2 p a) = W2 p (f a)

instance Comonad (W2 p) where
    extract (W2 p a) = a
    extend f w@(W2 p a) = W2 p (f w)

-- Stolen from Chris Penner's Comonads by Example

data Stream a = a :> Stream a deriving (Functor, Foldable)

-- A guess
instance (Show a) => Show (Stream a) where
    show (a :> (b :> (c :> (d :> (e :> _))))) = 
        show a <> " :> " <> show b <> " :> " <> show c <> " :> " <> show d <> " :> " <> show e <> " ..." 

instance Comonad Stream where
    extract (a :> _) = a
    -- A guess
    duplicate s@(a :> b) = s :> (duplicate b)

fromList :: [a] -> Stream a
fromList xs = go (cycle xs)
    where
        go (a:rest) = a :> go rest

countStream :: Stream Int
countStream = fromList [0..]

ix :: Int -> Stream a -> a
ix n _ | n < 0 = error "whoops"
ix 0 (a :> _) = a
ix n (_ :> rest) = ix (n - 1) rest

dropS :: Int -> Stream a -> Stream a
dropS n = ix n . duplicate

ix2 :: Int -> Stream a -> a
ix2 n = extract . dropS n

takeS :: Int -> Stream a -> [a]
takeS n input = take n (toList input)

filterS :: (a -> Bool) -> Stream a -> Stream a
filterS pred (a :> s) = if pred a then a :> fs else fs
    where fs = filterS pred s

rollingAvg :: Int -> Stream Int -> Stream Double
rollingAvg n s = undefined

evens, odds :: Stream Int
evens = filterS even countStream
odds = filterS odd countStream
-- End stolen

main ∷ IO ()
main = do
    print . runEnv $ env "hi" "a"
    print . snd . runStore $ store head "hey"
    print $ (runTraced $ traced head) "hello"
    print . extract $ mc
    print . duplicate $ mc
    print . extend (\(MyComonad a) -> a + 1) $ mc
    print . extract . extend (\(MyComonad a) -> a + 1) $ mc