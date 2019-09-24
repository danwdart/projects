import Control.Monad
import Control.Monad.IO.Class (MonadIO(..))
import Control.Concurrent.MVar (takeMVar, putMVar, newEmptyMVar)

import Data.Function ((&))
import Data.Functor ((<&>))
import Data.Maybe

import GHCJS.DOM
import GHCJS.DOM.AudioContext
import GHCJS.DOM.CanvasPath
import GHCJS.DOM.CanvasRenderingContext2D
import GHCJS.DOM.Document
import GHCJS.DOM.Element
import GHCJS.DOM.EventM
import GHCJS.DOM.GlobalEventHandlers
import GHCJS.DOM.HTMLCanvasElement
import GHCJS.DOM.HTMLHyperlinkElementUtils  
import GHCJS.DOM.Node
import GHCJS.DOM.Types
import GHCJS.DOM.WebGL2RenderingContext

import Language.Javascript.JSaddle.Debug
import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Warp

helloMain :: JSM ()
helloMain = do
    doc <- currentDocumentUnchecked
    body <- getBodyUnchecked doc
    setInnerHTML body "<h1>Hello, in HTML</h1>"

    -- Add a mouse click event handler to the document
    _ <- on doc click $ do
        (x, y) <- mouseClientXY
        newParagraph <- uncheckedCastTo HTMLParagraphElement <$> createElement doc "p"
        text <- createTextNode doc $ "Click location was " ++ show (x, y)
        appendChild_ newParagraph text
        appendChild_ body newParagraph

    -- Make an exit link
    exitMVar <- liftIO newEmptyMVar
    exit <- uncheckedCastTo HTMLAnchorElement <$> createElement doc "a"
    text <- createTextNode doc "Click here to exit"
    appendChild_ exit text
    appendChild_ body exit

    -- Set an href for the link, but use preventDefault to stop it working
    -- (demonstraights synchronous callbacks into haskell, as preventDefault
    -- must be called inside the JavaScript event handler function).
    setHref exit ""
    _ <- on exit click $ preventDefault >> liftIO (putMVar exitMVar ())

    -- Force all all the lazy JSaddle evaluation to be executed
    syncPoint

    -- Wait until the user clicks exit.
    liftIO $ takeMVar exitMVar
    setInnerHTML body "<h1>You clicked me.</h1>"

main :: IO ()
main = debug 5000 helloMain

serve :: IO ()
serve = debug 5000 (return ())

log :: JSM ()
log = void $ jsg "console" # "log" $ ["Hi folks!"]

logOnAll :: IO ()
logOnAll = runOnAll_ $ jsg "console" # "log" $ ["Hi folks!"]

-- Prints Maybe Bool properly - but there's no answer if not that
getConfirmFromClient :: JSM Bool
getConfirmFromClient = do
    info <- jsg1 "confirm" ["Are you sure?"]
    v <- fromJSVal $ info
    return . fromJust $ v

-- Prints Maybe String but includes Maybe "null" - JSNull should be Nothing?
getPromptFromClient :: JSM (Maybe String)
getPromptFromClient = do
    info <- jsg1 "prompt" ["What is your name"]
    fromJSVal $ info -- no need to return because returns anyway

newContextFromNewCanvas :: JSM CanvasRenderingContext2D
newContextFromNewCanvas = do
    d <- currentDocumentUnchecked 
    b <- getBodyUnchecked d
    c <- createElement d "canvas"
    setAttribute c "height" "800px"
    setAttribute c "width" "800px"
    canNode <- appendChild b c
    let canEl = uncheckedCastTo HTMLCanvasElement canNode
    mCtx <- getContext canEl "2d" [""]
    let gCtx = fromJust mCtx
    return . uncheckedCastTo CanvasRenderingContext2D $ gCtx

line :: Double -> Double -> Double -> Double -> CanvasRenderingContext2D -> JSM ()
line x1 y1 x2 y2 ctx = do
    beginPath ctx
    moveTo ctx x1 y1
    lineTo ctx x2 y2
    stroke ctx

drawOnNewCanvas :: JSM ()
drawOnNewCanvas = do
    ctx <- newContextFromNewCanvas
    setStrokeStyle ctx "1px solid black"
    line 100 100 700 700 ctx
    line 100 700 700 100 ctx
    

-- getCtx :: JSM Context

getBodies :: JSM String
getBodies = currentDocumentUnchecked >>= getBodyUnchecked >>= getInnerHTML <&> fromJSString