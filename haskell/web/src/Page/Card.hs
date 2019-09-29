{-# LANGUAGE OverloadedStrings #-}

module Page.Card (Language (..), imagesFs, Repo (..), card, cardDefunct) where

-- import Data.String
import Distribution.SPDX
import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A
import Page.GitHub

imagesFs :: [(Language, AttributeValue)]
imagesFs = [
    (LangJS, "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"),
    (LangHTML, "https://upload.wikimedia.org/wikipedia/commons/thumb/6/61/HTML5_logo_and_wordmark.svg/512px-HTML5_logo_and_wordmark.svg.png"),
    (LangPHP, "https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/PHP-logo.svg/711px-PHP-logo.svg.png"),
    (LangASM, "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Motorola_6800_Assembly_Language.png/800px-Motorola_6800_Assembly_Language.png"),
    (LangGNU, "https://upload.wikimedia.org/wikipedia/en/2/22/Heckert_GNU_white.svg"),
    (LangTS, "https://rynop.files.wordpress.com/2016/09/ts.png?w=200")
    (LangCoffee, "https://farm8.staticflickr.com/7212/7168325292_16a46a1fea_n.jpg"),
    (LangShell, "https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Antu_bash.svg/512px-Antu_bash.svg.png"),
    (LangGeneric, "https://web.archive.org/web/20181125122112if_/https://upload.wikimedia.org/wikipedia/commons/1/1a/Code.jpg")
    (LangPython, "https://upload.wikimedia.org/wikipedia/commons/0/0a/Python.svg"),
    (LangBlitzBasic, "https://upload.wikimedia.org/wikipedia/en/6/65/BlitzBasicLogo.gif"),
    (LangC, "https://upload.wikimedia.org/wikipedia/commons/3/3b/C.sh-600x600.png"),
    (LangTcl, "https://upload.wikimedia.org/wikipedia/commons/4/41/Tcl.svg"),
    (LangCPP, "https://upload.wikimedia.org/wikipedia/commons/5/5c/Images_200px-ISO_C%2B%2B_Logo_svg.png"),
    ]
    

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

renderCard :: Repo -> Html
renderCard repo = do
    H.div ! class_ "card col-md-4 text-center" $ H.div ! class_ "card-body" $ do
        img ! class_ "card-img-top-github" ! src $ languageImage . language $ repo
        h4 ! class_ "card-title" $ do
            H.span ! class_ "name" $ name repo
            H.span ! class_ "stars" $ "(" <> show . stars repo <> "★)"
            H.span ! class_ "fork" $ "⑂"
        p ! class_ "card-text" $ do
            H.span ! class_ "description" $ desc repo
            br
            a ! href ("https://spdx.org/licenses/" <> (licence repo) <> ".html") ! target "_blank" $ licence repo
            small $ em "Not yet licenced"
        a ! class_ "btn btn-secondary" ! href (source repo) ! target "_blank" $ "Source"
        a ! class_ "btn btn-secondary" ! href (website repo) ! target "_blank" $ "Website"