{-# LANGUAGE UnicodeSyntax #-}
import           GHCJS.DOM
import           GHCJS.DOM.Document
import           GHCJS.DOM.Element
import           GHCJS.DOM.Node
import           GHCJS.DOM.Types

import           Language.Javascript.JSaddle.Object
import           Language.Javascript.JSaddle.Warp

main ∷ IO ()
main = run 5000 jsMain

jsMain ∷ JSM()
jsMain = do
    pure ()
