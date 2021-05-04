{-# LANGUAGE TypeApplications #-}
{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-unused-matches #-}

import Control.Monad.Random
import Data.List
import Data.Maybe
-- import System.Random

default (Int)

newtype Tile = Tile Int

instance Show Tile where
    show (Tile x) = show @Int . fromInteger $ 2 ^ x

newtype Space = Space (Maybe Tile)

instance Show Space where
    show (Space Nothing) = "_"
    show (Space x) = show x

type Coord = (Int, Int)
type Coords = [Coord]

newtype Board = Board [[Space]]

instance Show Board where
    show (Board b) = intercalate "\n" $ showRow <$> b where
        showRow x = unwords $ show <$> x

data Direction = U | D | L | R

blankBoard :: Int -> Int -> Board
blankBoard rows cols = Board $ replicate rows $ replicate cols (Space Nothing)

iter :: Int -> (a -> a) -> a -> a
iter 0 _ x = x
iter 1 f x = f x
iter i f x = iter (i - 1) f x

iterA :: Applicative f => Int -> (a -> f a) -> a -> f a
iterA 0 _ x = pure x
iterA 1 f x = f x
iterA i f x = iterA (i - 1) f x

initialise :: MonadRandom m => Board -> m Board
initialise = iterA 2 fillRandomFreeSpace

poke :: Space -> Coord -> Board -> Board
poke s (x, y) (Board b) = undefined

-- Warning partial
peek :: Coord -> Board -> Space
peek (x, y) (Board rows) = rows !! x !! y

isFreeSpace :: Coord -> Board -> Bool
isFreeSpace coord board = isNothing x where
    (Space x) = peek coord board

allSpaces :: Board -> Coords
allSpaces _ = (,) <$> [0..3] <*> [0..3]

freeSpaces :: Board -> Coords
freeSpaces b = filter (`isFreeSpace` b) (allSpaces b)

fillSpace :: Coord -> Space -> Board -> Board
fillSpace (x, y) s b = undefined

randomFreeSpace :: MonadRandom m => Board -> m Coord
randomFreeSpace = uniform . freeSpaces

fillRandomFreeSpace :: MonadRandom m => Board -> m Board
fillRandomFreeSpace b = do
    coord <- randomFreeSpace b
    pure $ fillSpace coord (Space (Just (Tile 2))) b

slide :: Direction -> Board -> Board
slide = undefined

getDirection :: Direction -> Coord -> Board -> Space
getDirection = undefined

isFullSpace :: Space -> Bool
isFullSpace (Space x) = isJust x

isFull :: Board -> Bool
isFull (Board rows) = all isFullRow rows where
    isFullRow = all isFullSpace

main :: IO ()
main = do
    startBoard <- initialise $ blankBoard 4 4
    print startBoard