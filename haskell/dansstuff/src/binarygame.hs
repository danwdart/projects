import Control.Monad
import System.Console.ANSI
import System.IO

process :: Char -> IO ()
process = undefined

loop :: Char -> IO ()
loop key = if key == '\ESC'
    then
        putStrLn "Bye"
    else
        do
            process key
            getChar >>= loop
            return ()

data Point2D = Point2D {
    x :: Int,
    y :: Int
}

data Button = Button {
    text :: String,
    location :: Point2D
}

data ButtonProperties = ButtonProperties {
    selected :: Bool
}

renderButton :: Button -> ButtonProperties -> String
renderButton b bp = setCursorPositionCode (y $ location b) (x $ location b) ++
    setSGRCode [SetColor Foreground Vivid Green] ++
    "[[ " ++
    setSGRCode [Reset] ++
    text b ++
    setSGRCode [SetColor Foreground Vivid Green] ++
    " ]]" ++
    setSGRCode [Reset]

instance Show GameState where
    show gs = "<<GameState>>"

{-
    show b = 
-}

makeInitialButtons :: [Button]
makeInitialButtons = map (
    \n -> Button {text = "0", location = Point2D (n * 10) 0})
    [0..7]

data GameState = GameState {
    selectedButton :: Int,
    buttonValues :: [Int]
}

gameState :: GameState
gameState = GameState 0 $ replicate 8 0

select :: Int -> [Button] -> [Button]
select n btns = undefined

resetGame :: IO ()
resetGame = do
    hideCursor
    hSetEcho stdin False
    hSetBuffering stdin NoBuffering
    clearScreen
    setCursorPosition 0 0

resetTerm :: IO ()
resetTerm = showCursor

main :: IO ()
main = do
    resetGame
    --getChar >>= loop
    print gameState
    resetTerm