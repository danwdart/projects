import Data.List
import Data.Maybe
import Control.Monad

power = 0.5 :: Double
-- base = 10

ssp :: String -> String -> Maybe Int
ssp needle haystack = (findIndex . isPrefixOf) needle (tails haystack)

substringPosition :: String -> String -> Maybe Int
substringPosition haystack = ($ tails haystack) . findIndex . isPrefixOf

foundMsg :: Int -> Double -> Int -> String
foundMsg number root position = "Found " ++ show number ++
    " at position " ++ show position ++
    " on " ++ show root

intThenLength :: Double -> Int
intThenLength = length . show . floor

boolToMaybe :: Bool -> a -> Maybe a
boolToMaybe True = Just
boolToMaybe False = const Nothing

maybeApplyToSecondIf :: (t1 -> t2 -> Bool) -> (t2 -> a) -> t1 -> t2 -> Maybe a
maybeApplyToSecondIf comparator positionToFoundMessage one two = boolToMaybe (comparator one two) ( positionToFoundMessage two )

mapping :: Int -> Maybe String
mapping number = maybeApplyToSecondIf (>) positionToFoundMessage resultLength =<< maybePosition where
    root = (fromIntegral number :: Double) ** power -- ** is like ^ but for non-integrals
    resultLength = intThenLength root
    notDot = (/='.')
    rootWithoutDots = filter notDot (show root)
    maybePosition = substringPosition rootWithoutDots (show number)
    positionToFoundMessage = foundMsg number root

main :: IO ()
main = print (take 1000 $ mapMaybe mapping [1..])