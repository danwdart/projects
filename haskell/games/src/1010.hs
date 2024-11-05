{-# LANGUAGE OverloadedLists #-}
{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-unused-imports #-}

module Main (main) where

import Data.Map    (Map)
import Data.Map    qualified as M
import Data.Monoid
import Data.Set    (Set)
import Data.Set    qualified as S

height, width ∷ Int
height = 10
width = 10

data Coord = Coord (Sum Int) (Sum Int) deriving stock (Eq, Ord, Show)

instance Semigroup Coord where
    Coord x1 y1 <> Coord x2 y2 = Coord (x1 <> x2) (y1 <> y2)

newtype Board = Board (Set Coord)
    deriving stock (Eq, Ord, Show)
    deriving newtype (Monoid, Semigroup)

newtype Tile = Tile (Set Coord) deriving stock (Eq, Ord, Show)

availableTiles ∷ Set Tile
availableTiles = [
        Tile [Coord 0 0],
        Tile [Coord 0 0, Coord 0 1],
        Tile [Coord 0 0, Coord 1 0]
    ]

hasSquare ∷ Coord → Board → Bool
hasSquare coord (Board coords) = S.member coord coords

emptyBoard ∷ Board
emptyBoard = Board []

placeSquare ∷ Coord → Board → Maybe Board
placeSquare coord board@(Board coords) = if hasSquare coord board
    then Nothing
    else Just $ Board (S.insert coord coords)

foldMapA ∷ (Foldable t, Applicative f, Monoid b) ⇒ (a → f b) → t a → f b
foldMapA f = getAp . foldMap (Ap . f)

moveTile ∷ Coord → Tile → Tile
moveTile coord (Tile coords) = Tile (S.map (<> coord) coords)

placeTile ∷ Tile → Board → Maybe Board
placeTile (Tile coords) board = foldMapA (`placeSquare` board) coords

main ∷ IO ()
main = do
    print emptyBoard
