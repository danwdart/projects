{-# LANGUAGE UnicodeSyntax #-}
import           Control.Applicative
import           Control.Arrow
import           Control.Monad
import           Data.Char
import           Data.Function
import           Data.Functor
import           Data.List

a1 x = x ++ " " ++ show (length x)

a2 = unwords . ap [id, show.length] . pure

a3 = pure >>> ap [id, show.length] >>> unwords

b1 = undefined

main1 = getLine <&> fmap toUpper <&> words <&> intercalate "-" <&> replicate 2 <&> unwords <&> a2

-- main2 =
