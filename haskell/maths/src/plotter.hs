{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-unused-matches -Wno-unused-imports #-}

import           Codec.Picture
import           Data.Numbers.Primes
import           Data.Tuple

{-# ANN module "HLint: ignore" #-}

black, white ∷ PixelRGB8
black = PixelRGB8 0 0 0
white = PixelRGB8 255 255 255

red, blue, green, cyan, magenta, yellow ∷ PixelRGB8
red = PixelRGB8 255 0 0
blue = PixelRGB8 0 255 0
green = PixelRGB8 0 0 255
cyan = PixelRGB8 0 255 255
magenta = PixelRGB8 255 0 255
yellow = PixelRGB8 255 255 0

width, height ∷ Int
width = 500
height = 500

matrixToLinear ∷ (Int, Int) → Int
matrixToLinear (x, y) = width * y + x

linearToMatrix ∷ Int → (Int, Int)
linearToMatrix = swap . flip divMod width

matrixToLinearUlam ∷ (Int, Int) → Int
matrixToLinearUlam = undefined

linearUlamToMatrix  ∷ Int → (Int, Int)
linearUlamToMatrix = undefined

genCircles ∷ Int → Int → PixelRGB8
genCircles x y
    | res > 500 = black
    | res > 300 = red
    | res > 200 = green
    | res > 100 = blue
    | otherwise = white
    where res = (x^(2 :: Int) + y^(2 :: Int)) `mod` 1000

genDemo ∷ Int → Int → PixelRGB8
genDemo x y
    | n `mod` 2 == 0 = red
    | n `mod` 3 == 0 = yellow
    | n `mod` 5 == 0 = green
    | n `mod` 7 == 0 = blue
    | n `mod` 11 == 0 = black
    | otherwise = white
    where n = matrixToLinear (x, y)

genDemo2 ∷ Int → Int → PixelRGB8
genDemo2 x y
    | n `mod` 11 == 0 = black
    | n `mod` 7 == 0 = blue
    | n `mod` 5 == 0 = green
    | n `mod` 3 == 0 = yellow
    | n `mod` 2 == 0 = red
    | otherwise = white
    where n = matrixToLinear (x, y)

genDemo3 ∷ Int → Int → PixelRGB8
genDemo3 x y
    | round (sin (fromIntegral x) :: Double) == y = black
    | otherwise = white

genSines ∷ Int → Int → PixelRGB8
genSines x y = black
    -- where n = matrixToLinear (x, y)

main ∷ IO ()
main = do
    writePng "circles.png" $ generateImage genCircles width height
    writePng "demo.png" $ generateImage genDemo width height
    writePng "demo2.png" $ generateImage genDemo2 width height
    writePng "demo3.png" $ generateImage genDemo3 width height
    writePng "sines.png" $ generateImage genSines width height
