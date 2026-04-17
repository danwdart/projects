module Main where

main :: IO ()
main = pure ()

data Player = PlayerOne | PlayerTwo
    deriving (Enum, Bounded)

data GameStatus = Next Player | Won Player

type Line = [Int]

-- remembering that "won" is most stones and "end" is one side empty...
data Board = Board {
    mancala :: (Int, Int),
    board :: (Line, Line)
}

startingPosition :: Board
startingPosition = Board {
    mancala = (0, 0),
    board = (replicate 6 4, replicate 6 4)
}

-- Simplest thing possible for now
data Game = Game {
    gameStatus :: GameStatus
    board :: Board
}

{-}
[ ] [0:0 0][0:1 0][0:2 0][0:3 0][0:4 0][0:5 0] [0]
[ ]                    [ ]
[ ] [ ][ ][ ][ ][ ][ ] [ ]
-}

move :: Player -> Int -> Board -> Board
move player indexFile Board { mancala, board } = Board {
    mancala = 
}