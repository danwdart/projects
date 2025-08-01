module Chart (seqToPng) where

import Graphics.Rendering.Chart.Backend.Cairo
import Graphics.Rendering.Chart.Easy

seqToPng ∷ FilePath → String → String → Integer -> [Integer] → IO ()
seqToPng fileName plotTitle lineTitle startingIndex numberSequence = toFile @(Layout Integer Integer) def fileName $ do
    layout_title .= plotTitle
    plot (line lineTitle [ zip [startingIndex..] numberSequence ])