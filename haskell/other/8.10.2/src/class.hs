{-# LANGUAGE UnicodeSyntax #-}
class (Show a) => ThreePlusableToString a where
    (+++) :: a -> a -> String

class (Show a) => FourPlusableToString a where
    (++++) :: a -> a -> String
    x ++++ y = "1: " <> (show x <> (" 2: " <> show y))

data MyEnums = Enum1 | Enum2 | Enum3

instance ThreePlusableToString MyEnums where
    Enum1 +++ Enum2 = "Enum 1 and 2"
    x +++ y = show x <> (" & " <> show y)

instance FourPlusableToString MyEnums

instance Show MyEnums where
    show Enum1 = "One"
    show Enum2 = "Two"
    show _ = "Other"

class (Show a) => ConcatNum a where
    (|+) :: a -> a -> String
    x |+ y = show x <> show y

instance ConcatNum Int

main ∷ IO ()
main = print [
    [
        Enum1 +++ Enum2,
        Enum2 +++ Enum3,
        Enum3 +++ Enum1
    ],
    [
        Enum1 ++++ Enum2,
        Enum2 ++++ Enum3,
        Enum3 ++++ Enum1
    ],
    [
        (1 :: Int) |+ (8 :: Int)
    ]]
