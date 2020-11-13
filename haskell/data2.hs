data Point = Point Double Double deriving (Show)

data Shape = Circle Point Double | Square Point Point deriving (Show)

infoShape :: Shape -> String
infoShape (Circle centre radius) = "It's a circle!"
-- infoShape (Square topleft bottomRight) = 2

main = print $ infoShape (Circle (Point 1.0 2.0) 3.0)