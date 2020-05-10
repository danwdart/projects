import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Game

window :: Display
window = FullScreen -- InWindow "Game" (1720,880) (100, 100)

bgColour :: Color
bgColour = black

data World = World

initialGame :: World
initialGame = World

gameAsPicture :: World -> Picture
gameAsPicture = const $ Pictures [
    Translate (-500) 400 $ Color white $ Text "Airse",
    Translate 0 0 $ Color white $ Circle 100
    ]

transformGame :: Event -> World -> World
transformGame = const id

stepTime :: Float -> World -> World
stepTime = const id

fps :: Int
fps = 30

game :: IO ()
game = play
    window
    bgColour
    fps
    initialGame
    gameAsPicture
    transformGame
    stepTime

main :: IO ()
main = game