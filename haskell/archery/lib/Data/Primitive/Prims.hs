module Data.Primitive.Prims where

data Prims a b where
    ReverseString :: Prims String String
    Equal :: Eq a => Prims (a, a) Bool

deriving instance Show (Prims a b)

instance ToJSON (Prims a b) where
    toJSON ReverseString = String "ReverseString"
    toJSON Equal = String "Equal"

instance Primitive (FreeFunc Prims) where
    reverseString = Lift ReverseString
    eq = Lift Equal