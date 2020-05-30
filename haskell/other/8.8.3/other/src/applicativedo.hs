{-# LANGUAGE ApplicativeDo #-}

import Data.Functor.Compose

main :: IO ()
main = print . getCompose $ c

c :: Compose [] [] (Char, Char)
c = do
    a <- Compose ["aa"]
    b <- Compose ["bb"]
    return (a, b)