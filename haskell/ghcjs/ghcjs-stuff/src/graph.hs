{-# LANGUAGE JavaScriptFFI #-}
{-# LANGUAGE Unsafe        #-}
{-# OPTIONS_GHC -Wno-unused-matches -Wno-unused-top-binds -Wno-unused-imports #-}

module Main (main) where

import GHCJS.DOM
import GHCJS.DOM.Types
-- import GHCJS.Types
import GHCJS.DOM.Document
import GHCJS.DOM.HTMLCanvasElement
import GHCJS.DOM.CanvasPath
import GHCJS.DOM.CanvasRenderingContext2D

foreign import javascript unsafe "window.alert($1)" js_alert :: JSString → IO ()
foreign import javascript unsafe "console.log($1)" js_log :: JSVal → IO ()
foreign import javascript unsafe "document.body.appendChild($1)" js_append :: JSVal → IO ()

data Point2D = Point2D {
    x :: Double,
    y :: Double
}

data Line2D = Line2D {
    from :: Point2D,
    to   :: Point2D
}

-- ctx :: Reader

draw ∷ Line2D → RenderingContext → IO ()
draw (Line2D (Point2D x0 y0) (Point2D x1 y1)) ctx = do
    beginPath ctx
    moveTo x0 y0 ctx
    lineTo x1 y1 ctx
    stroke ctx

drawGrid ∷ RenderingContext → IO ()
drawGrid ctx = pure () -- do
    -- mapM_ (`draw` ctx) . (\n -> Line2D (Point2D 0 (n * 50)) (Point2D 800 (n * 50))) [0.0..16.0]
    -- mapM_ (`draw` ctx) . (\n -> Line2D (Point2D (n * 50) 0) (Point2D (n * 50) 800)) [0.0..16.0]

-- fillGridSquare :: Int -> Int -> C.Context -> IO ()

main ∷ IO ()
main = do
    c <- _create 800 800
    js_append $ jsval c
    ctx <- getContextUnsafe c
    js_setStrokeStyle ctx "0 0 0 1.0" 
    drawGrid ctx
