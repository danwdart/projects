{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-unused-top-binds #-}

module Main (main) where

import Control.Monad (void)
import Control.Monad.IO.Class
import Control.Monad.State
import Data.Bool
import Data.Foldable
import Data.List.Index
import System.Console.ANSI
import System.IO

process ∷ Char → [Button] → [Button]
process = toggle . pred . read . pure

render ∷ (MonadState [Button] m, MonadIO m) ⇒ m String
render = do
    liftIO resetGame
    st <- get
    modify $ select 1
    traverse_ (liftIO . putStr . renderButton) st
    ch <- liftIO getChar
    put $ process ch st
    render

data Point2D = Point2D {
    x :: Int,
    y :: Int
}

data Button = Button {
    text     :: String,
    location :: Point2D,
    selected :: Bool,
    spacing  :: Int
}

padding ∷ Button → Int
padding _ = 10

number ∷ Button → Int
number _ = 0

borderLeft ∷ Button → String
borderLeft = bool "[[" "<<" . selected

borderRight ∷ Button → String
borderRight = bool "]]" ">>" . selected

select ∷ Int → [Button] → [Button]
select n = modifyAt n selectButton

unselect ∷ Int → [Button] → [Button]
unselect n = modifyAt n unselectButton

toggle ∷ Int → [Button] → [Button]
toggle n = modifyAt n toggleButton

unselectAll ∷ [Button] → [Button]
unselectAll = fmap unselectButton

-- If only there was some kind of generic functor which worked on any parameter...
-- Could we make this in TH?
-- But tbh this would work with a map just fine.
-- Guess this is what a lens is for.
selectButton ∷ Button → Button
selectButton x = x {
    selected = True
}

unselectButton ∷ Button → Button
unselectButton x = x {
    selected = False
}

toggleButton ∷ Button → Button
toggleButton b@Button { selected } = b { selected = not selected }

type AnsiString = String

renderButton ∷ Button → AnsiString
renderButton b@Button {
    text,
    location = Point2D {
        x,
        y
    },
    spacing
} =
    setCursorPositionCode y x <> (
    setSGRCode [SetColor Foreground Vivid $ bool Yellow Green (selected b)] <> (
    borderLeft b <> (
    replicate spacing ' ' <> (
    setSGRCode [Reset] <> (
    text <> (
    setSGRCode [SetColor Foreground Vivid $ bool Yellow Green (selected b)] <> (
    replicate spacing ' ' <> (
    borderRight b <>
    setSGRCode [Reset]))))))))

makeInitialButtons ∷ [Button]
makeInitialButtons = fmap (
    \n -> Button {
        text = show n,
        location = Point2D (n * 10) 0,
        selected = False,
        spacing = 1
    }
    ) [1..9]

resetGame ∷ IO ()
resetGame = do
    hideCursor
    hSetEcho stdin False
    hSetBuffering stdin NoBuffering
    clearScreen
    setCursorPosition 0 0

resetTerm ∷ IO ()
resetTerm = showCursor

main ∷ IO ()
main = do
    void $ runStateT render makeInitialButtons
    resetTerm
