{-# LANGUAGE OverloadedStrings #-}

module Page.Social (socialIconB, socialIconS) where

-- import Data.String
import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A
    

socialIconB :: AttributeValue -> AttributeValue -> AttributeValue -> Html
socialIconB linkTitle linkHref iconName = a ! class_ "social" ! href linkHref ! A.style "color:black" ! A.title linkTitle ! target "_blank" ! rel "noopener" $ i ! class_ ("fab fa-" <> iconName) $ mempty

socialIconS :: AttributeValue -> AttributeValue -> AttributeValue -> Html
socialIconS linkTitle linkHref iconName = a ! class_ "social" ! href linkHref ! A.style "color:black" ! A.title linkTitle ! target "_blank" ! rel "noopener" $ i ! class_ ("fas fa-" <> iconName) $ mempty
