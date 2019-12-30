{-# LANGUAGE OverloadedStrings #-}

module Html.JolHarg.Index (page) where

import Data.JolHarg

import Html.Common.Card
import Html.Common.GitHub
import Html.Common.Head

import Network.HTTP.Req

import Text.Blaze.Html.Renderer.Utf8
import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A

pagePortfolio :: Html
pagePortfolio = li ! class_ "nav-item" $ do
    input ! type_ "radio" ! A.style "display:none" ! checked "checked" ! A.name "selected" ! A.id "Portfolio" ! value "Portfolio"
    H.label ! class_ "mb-0" ! for "Portfolio" $ a ! class_ "nav-link btn btn-sm" $ "Portfolio"
    H.div ! class_ "page" ! A.id "portfolio" $ do
        H.div ! class_ "row" $ H.div ! class_ "col my-md-3" $ small "» Portfolio"
        H.div ! class_ "row" $ H.div ! class_ "col-md-12 text-center" $ p "Some of the websites and projects JolHarg Ltd has been involved with are:"
        H.div ! class_ "row" $ do
            card "img/faultfixers.png" "FaultFixers" "Facilities management" "https://faultfixers.com"
            card "img/dadi.png" "DADI" "DADI web services suite" "https://dadi.cloud/en/"
            card "img/planetradio.png" "Planet Radio" "Collection of UK radio magazine websites" "https://planetradio.co.uk/"
            card "img/kompli.png" "Kompli Global" "Due diligence and search intelligence" "https://kompli-global.com"
            card "img/canddi.png" "CANDDi" "Smart web analytics" "https://canddi.com"
            card "img/cloudbanter.png" "Cloudbanter" "Mobile operator messaging system" "http://cloudbanter.com/"
            card "img/reviverest.png" "Revive Ad server REST API" "RESTful API for Open source ad server" "https://www.reviveadserverrestapi.com/"
            cardDefunct "ThemeAttic" "Inventors' search platform"
            card "img/soampli.png" "SoAmpli" "Social media amplification" "https://soampli.com"
            card "img/viewex.png" "Viewex" "Advertising revenue optimisation" "http://viewex.co.uk"
            card "img/mobilefun.png" "Mobile Fun" "Web shop for phones and accessories" "http://mobilefun.co.uk"
            card "img/gamingzap.png" "Gamingzap" "Web shop for gaming devices and accessories" "http://gamingzap.com"
            card "img/gearzap.png" "Gearzap" "Web shop for cases and accessories" "http://gearzap.com"
            card "img/rattray.png" "Rattray Mosaics" "Portfolio and personal website of local mosaic artist" "http://rattraymosaics.co.uk"
            card "img/smdaf.png" "Shepton Mallet Digital Arts Festival" "Local festival site" "http://sheptondigitalarts.co.uk"
            card "img/ssoha.png" "SSOHA" "Somerset School of Oriental Healing Arts" "http://ssoha.org.uk"

pageFs :: [Repo] -> Html
pageFs allRepos = li ! class_ "nav-item" $ do
    input ! type_ "radio" ! A.style "display:none" ! A.name "selected" ! A.id "Free Software" ! value "Free Software"
    H.label ! class_ "mb-0" ! for "Free Software" $ a ! class_ "nav-link btn btn-sm" $ "Free Software"
    H.div ! class_ "page" ! A.id "fs" $ do
        H.div ! class_ "row" $ H.div ! class_ "col my-md-3" $ small "» Free Software"
        H.div ! class_ "row" $ H.div ! class_ "col-md-12 text-center" $ p "Some of the free software projects JolHarg Ltd has created or contributed to are:"
        mapM_ renderCard allRepos

pageContact :: Html
pageContact = li ! class_ "nav-item" $ do
    input ! type_ "radio" ! A.style "display:none" ! A.name "selected" ! A.id "Contact" ! value "Contact"
    H.label ! class_ "mb-0" ! for "Contact" $ a ! class_ "nav-link btn btn-sm" $ "Contact"
    H.div ! class_ "page" ! A.id "contact" $ do
        H.div ! class_ "row" $ H.div ! class_ "col my-md-3" $ small "» Contact"
        H.div ! class_ "row" $ H.div ! class_ "col-lg-6 offset-lg-3 col-sm-12 col-md-12 col-xs-12 bg-light p-3 mb-3" $ do
            p "If you would like to contact JolHarg or make an enquiry, please use this form:"
            H.form ! action "https://formspree.io/website@jolharg.com" ! method "post" $ do
                H.div ! class_ "form-group" $ do
                    H.label ! for "name" $ "Your name"
                    input ! class_ "form-control" ! A.id "name" ! type_ "text" ! placeholder "John Smith" ! A.name "name" ! autocomplete "name"
                H.div ! class_ "form-group" $ do
                    H.label ! for "email" $ "Your email"
                    input ! class_ "form-control" ! A.id "email" ! type_ "email" ! placeholder "john@smith.com" ! A.name "email" ! autocomplete "email"
                    small ! class_ "form-text text-muted" ! A.id "emailHelp" $ "We'll never share your email with anyone else."
                H.div ! class_ "form-group" $ do
                    H.label ! for "subject" $ "Summary"
                    input ! class_ "form-control" ! A.id "subject" ! type_ "text" ! placeholder "Website for me..." ! A.name "_subject"
                H.div ! class_ "form-group" $ do
                    H.label ! for "message" $ "Your message"
                    textarea ! class_ "form-control" ! A.id "message" ! placeholder "I am interested in a website..." ! rows "10" ! A.name "message" $ mempty
                H.div ! class_ "form-group" $ input ! class_ "btn btn-primary" ! type_ "submit" ! value "Send"

htmlHeader :: [Repo] -> Html
htmlHeader allRepos = H.header $ nav ! class_ "p-0 p-sm-2 navbar d-block d-sm-flex navbar-expand navbar-dark bg-primary" $ do
    a ! class_ "w-75 p-0 pt-1 pt-sm-0 w-sm-auto text-center text-sm-left navbar-brand" ! href "" $ img ! src "/img/jolharg.png" ! A.style "height:32px" ! alt ""
    H.div $ ul ! class_ "navbar-nav px-3" $ do
        pagePortfolio
        --  +menuitem('Technologies')
        --    include ../pages/techs
        pageFs allRepos
        --  +menuitem('Pricing')
        --    include ../pages/pricing
        --  +menuitem('Blog')
        --    include ../pages/blog
        --  +menuitem('About')
        --    include ../pages/about
        pageContact

page :: [Repo] -> Html
page allRepos = docTypeHtml ! lang "en-GB" $ do
    htmlHead descTitle keywords
    htmlHeader allRepos