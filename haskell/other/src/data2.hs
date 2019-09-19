data Point = Point Double Double deriving (Show)

data Shape = Circle Point Double | Square Point Point deriving (Show)

infoShape :: Shape -> String
infoShape (Circle _ _) = "It's a circle!"
infoShape (Square _ _) = "2"

main :: IO ()
main = print $ infoShape (Circle (Point 1.0 2.0) 3.0)