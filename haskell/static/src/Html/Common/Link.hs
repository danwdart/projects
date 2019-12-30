{-# LANGUAGE OverloadedStrings #-}

module Html.Common.Link (extLink, extLinkTitle) where

import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A

extLink :: AttributeValue -> Html -> Html
extLink linkHref = a ! href linkHref ! target "_blank" ! rel "noopener"

extLinkTitle :: AttributeValue -> AttributeValue -> Html -> Html
extLinkTitle linkHref linkTitle = a ! href linkHref ! target "_blank" ! rel "noopener" ! A.title linkTitle
