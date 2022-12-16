module Shape where

data Point = Point Double Double deriving stock (Show)

data Shape = Circle Point Double | Square Point Point deriving stock (Show)

infoShape ∷ Shape → String
infoShape (Circle _ _) = "It's a circle!"
infoShape (Square _ _) = "2"