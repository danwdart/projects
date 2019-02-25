import Control.Monad
import Data.Function

main :: IO ()
change = (++ " Bob")
{-
Prelude> fmap print Just 1
Just 1
Prelude> return print Just 1
1
-}

-- main = getLine >>= putStrLn
-- main = return getLine putStrLn

(...) = (.) . (.)

-- main = join (fmap putStrLn getLine)
-- main = join $ fmap putStrLn getLine
-- main = (.) (.) (.) join fmap putStrLn getLine
-- main = (...) join fmap putStrLn getLine

-- main = fmap change getLine >>= putStrLn
-- main = return (fmap change getLine) putStrLn

-- main = return (fmap change (fmap change getLine)) putStrLn
-- main = fmap change (fmap change getLine) >>= putStrLn
-- main = ((fmap change) . (fmap change)) getLine
-- main = ((.) (fmap change) (fmap change)) getLine
join' a b = a b b

-- main = (fmap change $ fmap change $ fmap change getLine) >>= print

-- main = join $ fmap print $ fmap change $ fmap change $ fmap change getLine
-- main = getLine & fmap change & fmap change & fmap change & fmap print & join

-- main = join' (.) (fmap change) getLine

-- rrr a b c = a b (a b c)

-- foldl (&) "Bob" (replicate 5 change)

marp = (.) flip foldl (&) $ replicate 5 change

-- fmap marp getLine

-- foldl1, foldr1
e = product [1,2,3]
f = scanl (*) 1 [1,2,3]
g = scanl1 (*) [1,2,3]
h = takeWhile (<1000) [1..]

{-
Prelude Control.Monad Data.Function> 3 <$ [14]
[3]
-}

print =<< getLine