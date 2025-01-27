{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wno-x-partial #-}

module Main (main) where

import Data.Foldable
import GHCJS.DOM
import GHCJS.DOM.CanvasPath
import GHCJS.DOM.CanvasRenderingContext2D
import GHCJS.DOM.Document
import GHCJS.DOM.Element
import GHCJS.DOM.HTMLCanvasElement
import GHCJS.DOM.Node
import GHCJS.DOM.Types

-- add type aliases?
cartesianToGraph ∷ (Double, Double) → (Double, Double)
cartesianToGraph (x, y) = (x, 400 - y)

line ∷ (Double, Double) → (Double, Double) → CanvasRenderingContext2D → JSM ()
line (x1, y1) (x2, y2) ctx = do
    let (rx1, ry1) = cartesianToGraph (x1, y1)
    let (rx2, ry2) = cartesianToGraph (x2, y2)
    moveTo ctx rx1 ry1
    lineTo ctx rx2 ry2
    stroke ctx
{-
-- Retrieve the conXYZ-ascending-index pairs from a list
-- and pure them in another list
-- e.g. [1,2,3] -> [(1, 2), (2, 3)]
-}
pairs ∷ [a] → [(a,a)]
pairs a = zip a (case a of
   _ : xs -> xs
   []     -> error _)

-- like Graphics.Gnuplot.Plot.ThreeDimensional.functionToGraph
zipFn ∷ (a → b) → [a] → [(a, b)]
zipFn f = fmap (\x -> (x, f x)) -- both map but cba

getPoints ∷ Double → Double → Double → [Double]
getPoints startX endX skipX = enumFromThenTo startX (startX + skipX) endX

plotFormula ∷ (Double → Double) → Double → Double → Double → CanvasRenderingContext2D → JSM ()
plotFormula fn startX endX skipX ctx = do
    clearRect ctx 0 0 1600 800
    let points = getPoints startX endX skipX
    let p = pairs $ zipFn fn points
    traverse_ (\(p1, p2) -> line p1 p2 ctx) p

plotRecurrenceRelation ∷ (Double → Double) → Double → Double → Double → Double → Double → CanvasRenderingContext2D → JSM ()
plotRecurrenceRelation rr startY scaleY startX endX skipX ctx = do
    clearRect ctx 0 0 1600 800
    let pointsX = getPoints startX endX skipX
    let p = pairs . zip pointsX $ ((*scaleY) <$> iterate rr startY)
    traverse_ (\(p1, p2) -> line p1 p2 ctx) p

plotGraph ∷ CanvasRenderingContext2D → JSM ()
plotGraph ctx = do
    clearRect ctx 0 0 1600 800
    plotFormula ((200 *) . sin . (/ 100)) 0 1600 1 ctx
    plotRecurrenceRelation (1-) 0.2 350 0 1600 100 ctx
    plotRecurrenceRelation (\x -> 3.95 * (1 - x) * x) 0.2 350 0 1600 2 ctx
    plotRecurrenceRelation (\x -> 3.02 * (1 - x) * x) 0.2 350 0 1600 2 ctx

newCanvas ∷ Document → JSM HTMLCanvasElement
newCanvas doc = do
    canvas <- fromJSValUnchecked =<< toJSVal =<< createElement doc "canvas"
    setAttribute canvas "width" "1600px"
    setAttribute canvas "height" "800px"
    setAttribute canvas "style" "width: 1600px; height: 800px"
    pure canvas

getCanvasContext ∷ HTMLCanvasElement → JSM CanvasRenderingContext2D
getCanvasContext canvas = fromJSValUnchecked =<< toJSVal =<< getContextUnchecked canvas "2d" ([] :: [String])

jsMain ∷ JSM ()
jsMain = do
    doc <- currentDocumentUnchecked
    elBody <- getBodyUnchecked doc
    canvas <- newCanvas doc
    appendChild_ elBody canvas
    ctx <- getCanvasContext canvas
    plotGraph ctx

main ∷ IO ()
main = liftJSM jsMain
