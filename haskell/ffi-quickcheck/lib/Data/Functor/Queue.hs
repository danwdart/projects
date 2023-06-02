module Data.Functor.Queue where

data QueueF q a =
    NewF Int (q -> a) |
    PutF q Int a |
    GetF q (Int -> a) |
    SizeF q (Int -> a)
    deriving (Functor)