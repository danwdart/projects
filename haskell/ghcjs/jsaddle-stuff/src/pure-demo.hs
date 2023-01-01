{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString.Lazy.Char8       as BSL
import           JSDOM
import           JSDOM.Document
import           JSDOM.Element                    (setInnerHTML)
import           JSDOM.HTMLCollection
import           JSDOM.Types
import           Language.Javascript.JSaddle      hiding ((!))
import           Language.Javascript.JSaddle.Warp
import           Text.Blaze.Html.Renderer.Utf8
import qualified Text.Blaze.Html5                 as H (main)
import           Text.Blaze.Html5                 as H hiding (main)
import           Text.Blaze.Html5.Attributes      as A

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
    _ <- getElementsByTagName doc ("form" :: String) >>= flip itemUnchecked 0 >>= toJSVal >>= jsg ("console" :: String) # ("log" :: String)
    pure ()

main ∷ IO ()
main = run 5000 jsMain
