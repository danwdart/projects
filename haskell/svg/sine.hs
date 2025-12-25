#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/master.zip -p "haskell.packages.ghc914.ghcWithPackages(pkgs: with pkgs; [ blaze-svg ])" -i runghc

{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Data.List
import Data.String
import Text.Blaze.Svg11 as S
import Text.Blaze.Svg11.Attributes as A
import Text.Blaze.Svg.Renderer.Pretty

screenHeight, screenWidth :: Int
screenHeight = 200
screenWidth = 200

minX, minY, maxX, maxY :: Double
minX = -1
minY = -1
maxX = 1
maxY = 1

cartesianToPixel :: (Double, Double) -> (Int, Int)
cartesianToPixel (x, y) = (
    round (fromIntegral screenWidth * ((x - minX) / (maxX - minX))),
    round (fromIntegral screenHeight * ((y - minY) / (maxY - minY))))

quantiseByResolution :: Double -> [Double]
quantiseByResolution resolution = enumFromThenTo minX (minX + resolution) maxX

fn :: Double -> Double
fn = sin . (* 3)

coords :: [(Int, Int)]
coords = fmap cartesianToPixel $ fmap (\x -> (x, fn x)) $ quantiseByResolution 0.01

showCoord :: (Int, Int) -> String
showCoord (x, y) = show x <> ", " <> show y

coordToSVGHead :: (Int, Int) -> String
coordToSVGHead coord = "M" <> showCoord coord

coordToSVGTailElement :: (Int, Int) -> String
coordToSVGTailElement coord = "L" <> showCoord coord

coordsToSVGPathD :: [(Int, Int)] -> String
coordsToSVGPathD (c:cs) = coordToSVGHead c <> " " <> intercalate " " (fmap coordToSVGTailElement cs)

main :: IO ()
main = writeFile "sine.svg" . renderSvg $ doc

doc :: Svg
doc = docTypeSvg ! A.height (fromString $ show screenHeight) ! A.width (fromString $ show screenWidth) $ do
    S.path ! d (fromString $ coordsToSVGPathD coords) ! stroke "black" ! fill "transparent"