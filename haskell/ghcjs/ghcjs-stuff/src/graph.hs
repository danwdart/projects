{-# LANGUAGE JavaScriptFFI #-}
{-# LANGUAGE UnicodeSyntax #-}

import           Data.JSString         ()
import           GHCJS.DOM
import           GHCJS.Types
import qualified JavaScript.Web.Canvas as C

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

draw ∷ Line2D → C.Context → IO ()
draw (Line2D (Point2D x0 y0) (Point2D x1 y1)) ctx = do
    C.beginPath ctx
    C.moveTo x0 y0 ctx
    C.lineTo x1 y1 ctx
    C.stroke ctx

drawGrid ∷ C.Context → IO ()
drawGrid ctx = pure () -- do
    -- mapM_ (`draw` ctx) . (\n -> Line2D (Point2D 0 (n * 50)) (Point2D 800 (n * 50))) [0.0..16.0]
    -- mapM_ (`draw` ctx) . (\n -> Line2D (Point2D (n * 50) 0) (Point2D (n * 50) 800)) [0.0..16.0]

-- fillGridSquare :: Int -> Int -> C.Context -> IO ()

main ∷ IO ()
main = do
    c <- C.create 800 800
    js_append $ jsval c
    ctx <- C.getContext c
    C.strokeStyle 0 0 0 1.0 ctx
    drawGrid ctx
