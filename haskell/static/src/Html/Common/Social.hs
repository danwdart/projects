{-# LANGUAGE OverloadedStrings #-}

module Html.Common.Social (socialIconB, socialIconS) where

import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A

socialIconB :: AttributeValue -> AttributeValue -> AttributeValue -> Html
socialIconB linkHref linkTitle iconName = a ! class_ "social" ! href linkHref ! A.style "color:black" ! A.title linkTitle ! target "_blank" ! rel "noopener" $ i ! class_ ("fab fa-" <> iconName) $ mempty

socialIconS :: AttributeValue -> AttributeValue -> AttributeValue -> Html
socialIconS linkHref linkTitle iconName = a ! class_ "social" ! href linkHref ! A.style "color:black" ! A.title linkTitle ! target "_blank" ! rel "noopener" $ i ! class_ ("fas fa-" <> iconName) $ mempty
