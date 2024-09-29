-- Nonogram solver.
module Main where

import Prelude hiding (getLine)

main :: IO ()
main = pure ()

-- Graphics

filled :: Char
filled = '■'

unfilled :: Char
unfilled = '⮽'

unknown :: Char
unknown = '□'

-- Data types

newtype Clue = Clue {
    getClue :: Int
}

newtype Clues = Clues {
    getClues :: [Clue]
}

data Clueset = Clueset {
    columns :: Clues,
    rows :: Clues
}

class ToChar a where
    toChar :: a -> Char

data Cell = Unknown | Unfilled | Filled

instance ToChar Cell where
    toChar Unknown = unknown
    toChar Unfilled = unfilled
    toChar Filled = filled

newtype Line = Line {
    getLine :: [Cell]
}

class IsLine line where
    toLine :: line -> Line
    fromLine :: Line -> line

newtype Row = Row {
    getRow :: [Cell]
}

instance IsLine Row where
    toLine = Line . getRow
    fromLine = Row . getLine

newtype Col = Col {
    getCol :: [Cell]
}

instance IsLine Col where
    toLine = Line . getCol
    fromLine = Col . getLine

newtype Grid = Grid {
    getGrid :: [Row]
}

-- Classes

-- class IsGrid grid row col where
--     -- getRows :: grid -> [row] -- ?
--     getGridRow :: Int -> grid -> row
--     putGridRow :: Int -> row -> grid -> grid
--     getGridCol :: Int -> grid -> col
--     putGridCol :: Int -> col -> grid -> grid
--     -- _rows :: Lens' Grid Rows
--     -- _cols :: Lens' Grid Cols
-- 
-- -- yeah yeah...
-- -- TODO lenses
-- 
-- instance IsGrid Grid Row Col where
--     getGridRow n grid = getGrid grid !! n
--     putGridRow n row grid = undefined
--     getGridCol n grid = Col $ (!! n) . getRow <$> getGrid grid
--     putGridCol n col grid = undefined

-- Functions

solve :: Clueset -> Grid
solve = undefined

-- getPossibilitiesForClues :: IsLine line => Clues -> line -> line
-- getPossibilitiesForClues = undefined

-- How to do this:

-- [a, b, c]
-- if length of the unknown things = sum line + count line - 1, therefore the new row = replicate a filled, 1 unfilled, replicate b filled, 1 unfilled, replicate c filled
-- if it's smaller, die.

-- also do a "does it fit" thing.

-- If it stops it found a non-unique solution