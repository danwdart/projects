{-# LANGUAGE OverloadedStrings #-}
-- import Control.Monad
--import Control.Monad.IO.Class (MonadIO(..))
-- import Control.Concurrent.MVar (takeMVar, putMVar, newEmptyMVar)
import qualified Data.ByteString.Lazy.Char8 as BSL
-- import Data.Function ((&))
-- import Data.Functor ((<&>))
-- import Data.Maybe
-- import Data.String

import GHCJS.DOM
-- import GHCJS.DOM.AudioContext
-- import GHCJS.DOM.CanvasPath
-- import GHCJS.DOM.CanvasRenderingContext2D
import GHCJS.DOM.Document
import GHCJS.DOM.Element
-- import GHCJS.DOM.EventM
-- import GHCJS.DOM.GlobalEventHandlers
-- import GHCJS.DOM.HTMLCanvasElement
-- import GHCJS.DOM.HTMLHyperlinkElementUtils  
-- import GHCJS.DOM.Node
import GHCJS.DOM.Types
-- import GHCJS.DOM.WebGL2RenderingContext

-- import Language.Javascript.JSaddle.Debug
-- import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Warp

import Text.Blaze.Html.Renderer.Utf8
import Text.Blaze.Html5 as H hiding (main)
import qualified Text.Blaze.Html5 as H (main)
import Text.Blaze.Html5.Attributes as A

page :: Html
page = docTypeHtml ! lang "en-GB" $ do
    H.head $
        H.title "FRP Demo"
    body $ do
        header $
            h1 "FRP Demo"
        H.main $ do
            p "Hi"
            H.form $ do
                input ! A.type_ "text" ! A.name "text"
                input ! A.type_ "submit"
        footer $
            small "Made by JolHarg"

jsCode :: JSM ()
jsCode = do
    doc <- currentDocumentUnchecked
    elBody <- getBodyUnchecked doc
    setInnerHTML elBody $ BSL.unpack $ renderHtml page

serve :: JSM () -> IO ()
serve = run 5000

main :: IO ()
main = serve jsCode