{-# LANGUAGE OverloadedStrings #-}

module Html.Common.Card (Language (..), imagesFs, Repo (..), card, cardDefunct, renderCard) where

import Control.Monad

import Data.String
import Data.Maybe
import Distribution.SPDX

import Html.Common.GitHub as GH

import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A

genericImage :: AttributeValue
genericImage = "https://web.archive.org/web/20181125122112if_/https://upload.wikimedia.org/wikipedia/commons/1/1a/Code.jpg"

imagesFs :: [(Language, AttributeValue)]
imagesFs = [
    (LangJS, "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"),
    (LangHTML, "https://upload.wikimedia.org/wikipedia/commons/thumb/6/61/HTML5_logo_and_wordmark.svg/512px-HTML5_logo_and_wordmark.svg.png"),
    (LangPHP, "https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/PHP-logo.svg/711px-PHP-logo.svg.png"),
    (LangASM, "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Motorola_6800_Assembly_Language.png/800px-Motorola_6800_Assembly_Language.png"),
    (LangGNU, "https://upload.wikimedia.org/wikipedia/en/2/22/Heckert_GNU_white.svg"),
    (LangTS, "https://rynop.files.wordpress.com/2016/09/ts.png?w=200"),
    (LangCoffee, "https://farm8.staticflickr.com/7212/7168325292_16a46a1fea_n.jpg"),
    (LangShell, "https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Antu_bash.svg/512px-Antu_bash.svg.png"),
    (LangGeneric, genericImage),
    (LangPython, "https://upload.wikimedia.org/wikipedia/commons/0/0a/Python.svg"),
    (LangBlitzBasic, "https://upload.wikimedia.org/wikipedia/en/6/65/BlitzBasicLogo.gif"),
    (LangC, "https://upload.wikimedia.org/wikipedia/commons/3/3b/C.sh-600x600.png"),
    (LangTcl, "https://upload.wikimedia.org/wikipedia/commons/4/41/Tcl.svg"),
    (LangCPP, "https://upload.wikimedia.org/wikipedia/commons/5/5c/Images_200px-ISO_C%2B%2B_Logo_svg.png"),
    (LangHS, "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Haskell-Logo.svg/1280px-Haskell-Logo.svg.png"),
    (LangVB, "https://upload.wikimedia.org/wikipedia/en/e/e4/Visual_Basic_6.0_logo.png"),
    (LangDocker, "https://www.docker.com/sites/default/files/d8/2019-07/vertical-logo-monochromatic.png")
    -- TODO Haskell, VB, Docker
    ]

languageImage :: Language -> AttributeValue
languageImage l = fromMaybe genericImage (lookup l imagesFs)
    
card :: AttributeValue -> Html -> Html -> AttributeValue -> Html
card cardImage cardTitle cardText cardLink =  H.div ! class_ "card col-md-4 text-center" $ H.div ! class_ "card-body" $ do
    img ! class_ "card-img-top" ! src cardImage
    h4 ! class_ "card-title" $ cardTitle
    p ! class_ "card-text" $ cardText
    a ! class_ "btn btn-secondary" ! href cardLink ! target "_blank" ! rel "noopener" $ "Visit"

cardDefunct :: Html -> Html -> Html
cardDefunct cardTitle cardText = H.div ! class_ "card col-md-4 text-center" $ H.div ! class_ "card-body" $ do
    img ! class_ "card-img-top" ! src "img/sample.png"
    h4 ! class_ "card-title" $ cardTitle
    p ! class_ "card-text" $ cardText
    strong "Website defunct"

licenceLink :: Licence -> Html
licenceLink licence =  a ! href ("https://spdx.org/licenses/" <> fromString avOrHtmlSpdx <> ".html") ! target "_blank" $ fromString avOrHtmlSpdx
    where avOrHtmlSpdx = GH.spdx_id licence

renderCard :: Repo -> Html
renderCard repo =
    H.div ! class_ "card col-md-4 text-center" $ H.div ! class_ "card-body" $ do
        img ! class_ "card-img-top-github" ! A.src (languageImage . language $ repo)
        h4 ! class_ "card-title" $ do
            H.span ! class_ "name" $ fromString . GH.name $ repo
            " "
            H.span ! class_ "stars" $ "(" <> (fromString . show . stars $ repo) <> "★)"
            when (fork repo) $ H.span ! class_ "fork" $ "⑂"
        p ! class_ "card-text" $ do
            H.span ! class_ "description" $ fromString . fromMaybe "" $ GH.description repo
            br
            maybe (small $ em "Not yet licenced") licenceLink (licence repo)
        maybe "" (\src -> a ! class_ "btn btn-secondary mx-1" ! href (fromString src) ! target "_blank" $ "Source") (GH.source repo)
        maybe "" (\site -> a ! class_ "btn btn-secondary mx-1" ! href (fromString site) ! target "_blank" $ "Website") $ website repo