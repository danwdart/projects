{-# LANGUAGE OverloadedStrings #-}

module Page.Head (htmlHead) where

import Data.String
import Page.Utils
import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A

metas :: String -> [AttributeValue] -> Html
metas descTitle keywords = do
    meta ! charset "utf-8"
    mapM_ (\(aName, aCont) -> meta ! name aName ! content aCont) [
        ("description", fromString descTitle),
        ("keywords", intercalateAttr "," keywords)
        ]
    meta ! name "viewport" ! content "width=device-width, initial-scale=1"
    mapM_ (\(aHE, aCont) -> meta ! httpEquiv aHE ! content aCont) [
        ("Content-Type", "text/html; charset=utf-8"),
        ("Who-is-awesome", "Kaychan"),
        ("X-UA-Compatible", "IE=edge,chrome=1")
        ]

htmlHead :: String -> [AttributeValue] -> Html
htmlHead descTitle keywords = H.head $ do
    metas descTitle keywords
    link ! rel "shortcut icon" ! type_ "image/png" ! href "/img/favicon.png"
    link ! rel "stylesheet" ! type_ "text/css" ! href "https://fonts.googleapis.com/css?family=Caudex"
    link ! rel "stylesheet" ! type_ "text/css" ! href "/css/style.css"
    H.title $ toHtml descTitle