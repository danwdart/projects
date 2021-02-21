{-# LANGUAGE UnicodeSyntax #-}
import           Graphics.Gloss
import           Graphics.Gloss.Interface.IO.Game

window ∷ Display
window = FullScreen -- InWindow "Game" (1720,880) (100, 100)

bgColour ∷ Color
bgColour = black

newtype World = World {
    rot :: Float
}

initialGame ∷ World
initialGame = World 0

gameAsPicture ∷ World → Picture
gameAsPicture World {rot = rotd} = Pictures [
    Translate (-500) 400 . Color white $
            Text "Airse",
    Translate 0 0 . Color white $
            Circle 100,
    Rotate rotd . Color white $
            Text "Ahhhh!"
    ]

transformGame ∷ Event → World → World
transformGame = const id

stepTime ∷ Float → World → World
stepTime _ world = world {
    rot = rot world + 1
}

fps ∷ Int
fps = 25

game ∷ IO ()
game = play
    window
    bgColour
    fps
    initialGame
    gameAsPicture
    transformGame
    stepTime

main ∷ IO ()
main = game
