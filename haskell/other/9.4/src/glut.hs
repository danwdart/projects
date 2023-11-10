{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-unused-imports #-}

module Main (main) where

import Graphics.UI.GLUT
import Graphics.UI.GLUT.Begin
import Graphics.UI.GLUT.Initialization

main ∷ IO ()
main = do
    initialWindowPosition $= Position 100 100
    initialWindowSize $= Size 900 500
    _ <- initialize "OpenGL Demo" []
    _ <- createWindow "OpenGL Demo"
    displayCallback $= do
        putStrLn "Display!"
        pure ()
    closeCallback $= Just (do
        putStrLn "Close."
        exit)
    positionCallback $= Just (\pos -> do
        print pos)

    -- windowPosition $= Position 100 100
    -- windowSize $= Size 900 500
    -- cursor $= Spray
    -- mainLoop
    -- exit
    pure ()
