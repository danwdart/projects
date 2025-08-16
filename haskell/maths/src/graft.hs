module Main (main) where

import Data.Foldable
import Data.List     (findIndex, isPrefixOf, tails)
import Data.Maybe
-- import Control.Monad

-- power ∷ Double
-- power = 1 / 3
-- base = 10

fn ∷ Double → Double
-- fn = (** power)
-- fn = logBase 10
-- fn = exp
-- fn = tan
-- fn = (pi *)
fn = (exp 1 *)
-- ssp :: String -> String -> Maybe Int
-- ssp needle haystack = (findIndex . isPrefixOf) needle (tails haystack)

substringPosition ∷ String → String → Maybe Int
substringPosition haystack = flip (findIndex . isPrefixOf) (tails haystack)

foundMsg ∷ Int → Double → Int → String
foundMsg number root position = "Found " <> (show number <> (
    " at position " <> (show position <> (
    " on " <> show root))))

intThenLength ∷ Double → Int
intThenLength = length . show . (\x -> floor x :: Int)

boolToMaybe ∷ Bool → a → Maybe a
boolToMaybe True  = Just
boolToMaybe False = const Nothing

maybeApplyToSecondIf ∷ (t1 → t2 → Bool) → (t2 → a) → t1 → t2 → Maybe a
maybeApplyToSecondIf comparator positionToFoundMessage one two = boolToMaybe (comparator one two) ( positionToFoundMessage two )

mapping ∷ Int → Maybe String
mapping number = maybeApplyToSecondIf (>) positionToFoundMessage resultLength =<< maybePosition where
    root = fn . fromIntegral $ number -- ... so (**) is like (^) but for non-integrals
    resultLength = intThenLength root
    notDot = (/= '.')
    rootWithoutDots = filter notDot (show root)
    maybePosition = substringPosition rootWithoutDots (show number)
    positionToFoundMessage = foundMsg number root

main ∷ IO ()
main = traverse_ putStrLn (take 1000 $ mapMaybe mapping [1..])
