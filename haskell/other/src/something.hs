import Control.Arrow
import Data.Functor
import Data.Char
import Control.Monad
import Data.List
import Control.Applicative
import Data.Function

a1 x = x ++ " " ++ show (length x)

a2 = unwords . ap [id, show.length] . pure

a3 = pure >>> ap [id, show.length] >>> unwords

b1 = undefined

main1 = getLine <&> fmap toUpper <&> words <&> intercalate "-" <&> replicate 2 <&> unwords <&> a2

-- main2 = 