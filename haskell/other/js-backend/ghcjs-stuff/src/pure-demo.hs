{-# LANGUAGE JavaScriptFFI     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Unsafe            #-}

module Main (main) where

import Data.ByteString.Lazy.Char8       qualified as BSL
import GHCJS.DOM
import GHCJS.DOM.Document
import GHCJS.DOM.Element                (setInnerHTML)
-- import GHCJS.DOM.HTMLCollection
import GHCJS.DOM.ParentNode
import GHCJS.DOM.Types
import Text.Blaze.Html.Renderer.Utf8
import Text.Blaze.Html5                 as H hiding (main)
import Text.Blaze.Html5                 qualified as H (main)
import Text.Blaze.Html5.Attributes      as A

foreign import javascript unsafe
  "console.log($1)" consoleLogElement :: Element → JSM ()

page ∷ Html
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

jsMain ∷ JSM ()
jsMain = do
    doc <- currentDocumentUnchecked
    elBody <- getBodyUnchecked doc
    setInnerHTML elBody . BSL.unpack $ renderHtml page
    form' <- querySelectorUnchecked doc ("form" :: String)
    consoleLogElement form'
    pure ()

main ∷ IO ()
main = liftJSM jsMain
