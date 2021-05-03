{-# LANGUAGE TypeApplications #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import Data.List

default (Int)

newtype Tile = Tile Int

instance Show Tile where
    show (Tile x) = show @Int . fromInteger $ 2 ^ x

newtype Space = Space (Maybe Tile)

instance Show Space where
    show (Space Nothing) = "_"
    show (Space x) = show x

newtype Board = Board [[Space]]

instance Show Board where
    show (Board b) = intercalate "\n" $ show <$> b

type Coord = (Int, Int)
type Coords = [Coord]

blankBoard :: Board
blankBoard = Board $ replicate 4 $ replicate 4 (Space Nothing)

freeSpaces :: Board -> Coords
freeSpaces = undefined

randomFreeSpace :: Board -> Coord
randomFreeSpace = undefined

fillRandomFreeSpace :: Board -> Board
fillRandomFreeSpace = undefined

main :: IO ()
main = do
    print blankBoard