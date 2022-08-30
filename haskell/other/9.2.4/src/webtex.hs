{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-unused-top-binds #-}

module Main where

import           Control.Monad
import           Control.Monad.IO.Class
import           Control.Monad.Trans.State
import           Data.Bool
import           Data.List.Index
import           System.Console.ANSI
import           System.IO

data Point2D = Point2D {
    x :: Int,
    y :: Int
}

data Character = Character {
    text :: String,
    location :: Point2D
}

type AnsiString = String

renderCharacter ∷ Character → IO ()
renderCharacter (Character text (Point2D x y)) = putStrLn $ setCursorPositionCode y x <> text

resetGame ∷ IO ()
resetGame = do
    hideCursor
    hSetEcho stdin False
    hSetBuffering stdin NoBuffering
    clearScreen
    setCursorPosition 0 0

gameLoop :: IO ()
gameLoop = do
    renderCharacter (Character "---:->" (Point2D 2 2))
    hSetEcho stdin False
    char <- getChar
    unless ('q' == char) gameLoop


resetTerm ∷ IO ()
resetTerm = do
    hSetEcho stdin True
    showCursor

main ∷ IO ()
main = do
    resetGame
    gameLoop
    resetTerm
