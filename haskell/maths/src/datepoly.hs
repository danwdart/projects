{-
Make an equation in which a sequence is displayed in the y coordinates of the indices at x.
So use FDM https://www.youtube.com/watch?v=scQ51q_1nhw
e.g. 2  0  2  6      0 1        0 2
d:    -2 2   4     -6 1       -1 2
        4  2    -10  7      -2  3
         -2  -12   17    -9   5
           -10  29    -26  14
              39  -55    40
                -94   95
                   189

f(x) = sum(k=0..inf) diff(k)(0) x(x-1)(x-k+1) /k!

f(x) = 2
    - 2x
    + 4(x(x-1))/2
    -2 (x(x-1)(x-2))/6
    -10 (x)(x-1)(x-2)(x-3)/24
    +39 (x)(x-1)(x-2)(x-3)(x-4)/120
    -94 (x)(x-1)(x-2)(x-3)(x-4)(x-5)/720 
    +189 (x)(x-1)(x-2)(x-3)(x-4)(x-5)(x-6)/5040

f(x) = 2
    - 2x
    + 2x(x-1)
    -(1/3)x(x-1)(x-2)
    -(10/24)x(x-1)(x-2)(x-3)
    +(39/120)x(x-1)(x-2)(x-3)(x-4)
    -(94/720)x(x-1)(x-2)(x-3)(x-4)(x-5) 
    +(189/5040)x(x-1)(x-2)(x-3)(x-4)(x-5)(x-6)

f(x) = 2
    - 2x
    +2x(x-1)
    -(1/3)x(x-1)(x-2)
    -(5/12)x(x-1)(x-2)(x-3)
    +(13/40)x(x-1)(x-2)(x-3)(x-4)
    -(47/360)x(x-1)(x-2)(x-3)(x-4)(x-5) 
    +(3/80)x(x-1)(x-2)(x-3)(x-4)(x-5)(x-6)

2-2x+2x(x-1)-(1/3)x(x-1)(x-2)-(5/12)x(x-1)(x-2)(x-3)+(13/40)x(x-1)(x-2)(x-3)(x-4)-(47/360)x(x-1)(x-2)(x-3)(x-4)(x-5)+(3/80)x(x-1)(x-2)(x-3)(x-4)(x-5)(x-6)

(3 x^7)/80 - (661 x^6)/720 + (2123 x^5)/240 - (6095 x^4)/144 + (6229 x^3)/60 - (5389 x^2)/45 + (483 x)/10 + 2

(27 x^7 - 661 x^6 + 6369 x^5 - 30475 x^4 + 74748 x^3 - 86224 x^2 + 34776 x + 1440)/720

Then create a polyominal graph based on the date with numbers and post it every day.

Calculate it and display it below and explain as text

hints: https://www.desmos.com/calculator/kwj1wgxlnw

-}

{-# OPTIONS_GHC -Wwarn #-}

module Main (main) where

import Data.Foldable
import Data.Time
import Data.Time.Calendar.MonthDay
import Data.Time.Calendar.OrdinalDate
import Numeric.Natural
import Graphics.Rendering.Chart.Easy
import Graphics.Rendering.Chart.Backend.Cairo
import Polynomial
import Polynomial.Class
import Polynomial.Pretty
-- import Polynomial.NonEmpty

-- Date stuff
dateToList :: Num a => UTCTime -> [a]
dateToList utcTime = [
    fromIntegral millennium,
    fromIntegral century,
    fromIntegral decade,
    fromIntegral yearunits,
    fromIntegral monthtens,
    fromIntegral monthunits,
    fromIntegral daytens,
    fromIntegral dayunits
    ] where
        (year, dayOfYear) = toOrdinalDate . utctDay $ utcTime
        (month, day) = dayOfYearToMonthAndDay (isLeapYear year) dayOfYear
        (millennium, centyears) = divMod year 1000
        (century, decyears) = divMod centyears 100
        (decade, yearunits) = divMod decyears 10
        (monthtens, monthunits) = divMod month 10
        (daytens, dayunits) = divMod day 10

diff :: Num a => [a] -> [a]
diff xs = zipWith (-) (drop 1 xs) xs

fntimes :: Natural -> (a -> a) -> a -> a
fntimes 0 _ val = val
fntimes 1 f val = f val
fntimes n f val = f (fntimes (n - 1) f val)

initialDiffs :: Num a => [a] -> [a]
initialDiffs d0 = fmap (\s -> s !! 0) $ fmap (\n -> fntimes n diff d0) [0..(fromIntegral (length d0) - 1)]

fac :: (Num a, Enum a) => a -> a
fac n = product [1..n]

invfac :: (Integral a, Fractional b, Enum b) => a -> Polynomial b
invfac n = fromNumList [1 / fac (fromIntegral n)]

fallingFactorialX :: (Integral a, Fractional b) => a -> Polynomial b
fallingFactorialX 0 = 1
fallingFactorialX 1 = x
fallingFactorialX n = (x - (fromInteger (fromIntegral n)) + 1) * fallingFactorialX (n - 1)

-- 3/80x⁷ - 661/720x⁶ + 2123/240x⁵ - 6095/144x⁴ + 6229/60x³ - 5389/45x² + 483/10x + 2 ?
-- (191/5040)𝑥⁷ - (667/720)𝑥⁶ + (6419/720)𝑥⁵ - (6137/144)𝑥⁴ + (18803/180)𝑥³ - (10841/90)𝑥² + (3401/70)𝑥 + 2
polyFitting :: (Enum a, Fractional a) => [a] -> Polynomial a
polyFitting initialDiffs' = sum $ fmap (\(i, val) -> fromNumList [val] * fallingFactorialX @Integer i * invfac i) $ zip [0..] initialDiffs'

vals :: (EvalPoly p a) => p a -> [a] -> [(a, a)]
vals poly' xs = fmap (\val -> (val, evalPolyAt val poly')) xs

-- nrStep :: (Enum a, Fractional a) => Polynomial a -> a -> a
-- nrStep poly' guess = guess - (evalPolyAt guess poly' / evalPolyAt guess (differentiate poly'))

main :: IO ()
main = do
    now <- getCurrentTime
    let dateString = take 10 (show now)
    let d0 = dateToList now
    let initialDiffs' :: [Integer]
        initialDiffs' = initialDiffs d0

    let poly' :: Polynomial Rational
        poly' = polyFitting (fmap fromIntegral initialDiffs')
    let vals' :: [(Rational, Rational)]
        vals' = vals poly' [-1..8]
    putStrLn $ prettyPoly defaultPrettyPolyOptions $ poly'
    for_ vals' $ \(key, val) -> do
        putStrLn $ displayNum key <> ", " <> displayNum val

    -- we could do calculus or we could just do this...
    let polyG' :: Polynomial Double -- who needs Double?
        polyG' = polyFitting (fmap fromIntegral initialDiffs')
    let line' :: [(Double, Double)]
        line' = fmap (\val -> (val, evalPolyAt val polyG')) [-0.1, -0.09..7.1]

    let (minY, maxY) = (fromIntegral $ round (minimum vals), fromIntegral $ round (maximum vals)) where
        vals = fmap snd line'

    -- Let's draw it!

    toFile (def & fo_size .~ (1920,1080)
                & fo_format .~ SVG 
            ) ("polynomial-" <> dateString <> ".svg") $ do
            layout_title .= ("Today's Polynomial for " <> dateString)
            layout_title_style . font_size .= 48
            layout_legend ?= (def & legend_label_style . font_size .~ 26)
            layout_x_axis . laxis_override .= (axis_grid .~ [-1..8]) -- . (axis_labels .~ [fmap (\n -> (n, show (round n))) [-10..10]])
            layout_y_axis . laxis_override .= (axis_grid .~ [minY..maxY]) -- . (axis_labels .~ [fmap (\n -> (n, show (round n))) [-10..10]])
            -- layout_y_axis . laxis_generate .= const (autoScaledAxis def (autoSteps 10 [1..10]))
            -- Cairo doesn't like Unicode extended apparently
            plot (line (prettyPoly defaultPrettyPolyOptions { displayXFn = displayXAscii } $ poly') [line'])
            plot (points (show d0) (zip [0..] (fromIntegral <$> d0)))