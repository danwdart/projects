{-# LANGUAGE OverloadedStrings #-}

module Page.Link (extLink, extLinkTitle) where

-- import Data.String
import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A

extLink :: AttributeValue -> Html -> Html
extLink linkHref linkText = a ! href linkHref ! target "_blank" ! rel "noopener" $ linkText

extLinkTitle :: AttributeValue -> AttributeValue -> Html -> Html
extLinkTitle linkHref linkTitle linkText = a ! href linkHref ! target "_blank" ! rel "noopener" ! A.title linkTitle $ linkText
