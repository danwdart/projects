{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import           Control.Arrow
import           Control.Monad.Random
import           Data.Biapplicative
import           Data.List
import           Data.Maybe

main :: IO ()
main = pure ()

type El = Int
type Row = [El]
type Board = [Row]
type XCoord = Int
type YCoord = Int
type Coords = (XCoord, YCoord)
type Move = (Int, Coords)

emptyElement :: El
emptyElement = 0

height, width, horizVertMoveLength, diagonalMoveLength :: Int
height = 10
width = 10
horizVertMoveLength = 3
diagonalMoveLength = 2

bimapBoth :: Bifunctor f => (a -> b) -> f a a -> f b b
bimapBoth f = bimap f f

(.:) :: (c -> d) -> (a -> b -> c) -> a -> b -> d
(.:) = (.) (.) (.)

(!?) :: [a] -> Int -> Maybe a
xs !? i = if length xs > i then Just (xs !! i) else Nothing

-- stolen from yjtools
apply2way :: (a -> b -> c) -> (d -> a) -> (d -> b) -> d -> c
apply2way f g h = uncurry f . (g &&& h)

inRange :: Ord a => (a, a) -> a -> Bool
inRange (from, to) = apply2way (&&) (>= from) (<= to)

replaceListElement :: Int -> a -> [a] -> [a]
replaceListElement n x xs = take n xs <> ([x] <> drop (n + 1) xs)

isEmpty :: El -> Bool
isEmpty = (==) emptyElement

isPresent :: El -> Bool
isPresent = not . isEmpty

validCoords :: Coords -> Bool
validCoords (x, y) = inRange (0, width - 1) x &&
                     inRange (0, height - 1) y -- todo combinators

emptyBoard :: Board
emptyBoard = replicate height $ replicate width emptyElement

getRow :: YCoord -> Board -> Row
getRow = flip (!!)

getElOfRow :: XCoord -> Row -> El
getElOfRow = flip (!!)

getEl :: Coords -> Board -> El
getEl (x, y) board = getElOfRow x (getRow y board)

isCoordOccupied :: Coords -> Board -> Bool
isCoordOccupied = isEmpty .: getEl

replaceElInRow :: XCoord -> El -> Row -> Row
replaceElInRow = replaceListElement

replaceRow :: YCoord -> Row -> Board -> Board
replaceRow = replaceListElement

replaceEl :: Coords -> El -> Board -> Board
replaceEl (x, y) el board = replaceRow y (replaceElInRow x el $ getRow y board) board

chooseRandomAvailable :: Board -> Coords
chooseRandomAvailable = const (0, 0) -- TODO randomis

allMovesFrom :: Coords -> [Coords]
allMovesFrom (x, y) = filter validCoords [
    -- generate
    (x + horizVertMoveLength, y),
    (x - horizVertMoveLength, y),
    (x, y + horizVertMoveLength),
    (x, y - horizVertMoveLength),
    (x + diagonalMoveLength, y + diagonalMoveLength),
    (x - diagonalMoveLength, y + diagonalMoveLength),
    (x + diagonalMoveLength, y - diagonalMoveLength),
    (x - diagonalMoveLength, y - diagonalMoveLength)
    ]

validMoves :: Coords -> [Coords]
validMoves = filter validCoords . allMovesFrom

nextEl :: El -> El
nextEl = succ

move :: (MonadRandom m) => Move -> Board -> m (Maybe (Move, Board))
move (lastMoveElement, lastMoveCoords) board = do
    nextMoveCoords <- uniform $ validMoves lastMoveCoords
    let nextElement = nextEl lastMoveElement
    if isPresent $ getEl nextMoveCoords board then
        pure Nothing
    else do
        let board2 = replaceEl nextMoveCoords nextElement board
        pure . Just $ ((nextElement, nextMoveCoords), board2)

moveManualOptions :: Move -> Board -> Maybe (El, [Coords], Board)
moveManualOptions (lastMoveElement, lastMoveCoords) board = do
    let nextMovesCoords = validMoves lastMoveCoords
    let nextElement = nextEl lastMoveElement
    if all isPresent $ fmap (`getEl` board) nextMovesCoords then
        Nothing
    else Just (nextElement, nextMovesCoords, board)

autoPlay :: IO ()
autoPlay = do
    let board = emptyBoard
    let el = nextEl emptyElement
    let coord = chooseRandomAvailable board
    let board2 = replaceEl coord el board
    moveAndRender (el, coord) board2

moveAndRender :: Move -> Board -> IO ()
moveAndRender (el, coord) board2 = do
    putStrLn $ "Move " <> show el
    putStrLn $ renderBoard board2
    mmb <- move (el, coord) board2
    if isNothing mmb
        then putStrLn "Done"
        else do
            let Just (lastMove, lastBoard) = mmb
            moveAndRender lastMove lastBoard

renderBoard :: Board -> String
renderBoard = intercalate "\n" . fmap show

runUntilStopped :: (Eq a) => (a -> Maybe a) -> a -> Maybe a
runUntilStopped f a = do
    b <- f a
    runUntilStopped f b
