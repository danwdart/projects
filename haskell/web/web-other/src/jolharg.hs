{-# LANGUAGE OverloadedStrings #-}

-- import Control.Monad (forM_)
import qualified Data.ByteString.Lazy.Char8 as BSL
-- import Data.String
import Network.HTTP.Req
import Text.Blaze.Html.Renderer.Utf8
import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A
import Page.Card
import Page.GitHub
import Page.Head

main :: IO ()
main = do
    reposDan <- runReq defaultHttpConfig $ getRepos "dandart"
    print $ reposDan
    reposJH <- runReq defaultHttpConfig $ getRepos "jolharg"
    print $ reposJH
    print $ reposDan <> reposJH
    -- BSL.putStrLn . renderHtml $ page

keywords :: [AttributeValue]
keywords = [
    "dan",
    "dart",
    "software",
    "engineer",
    "mathematics",
    "lover",
    "radio",
    "ham",
    "php",
    "javascript",
    "css",
    "coffee",
    "coffeescript",
    "laravel",
    "zend",
    "framework",
    "linux",
    "gnu",
    "express.js",
    "ubuntu",
    "debian"
    ]

descTitle :: String
descTitle = "JolHarg: Engineering Software"

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

pageFs :: Html
pageFs = li ! class_ "nav-item" $ do
    input ! type_ "radio" ! A.style "display:none" ! A.name "selected" ! A.id "Free Software" ! value "Free Software"
    H.label ! class_ "mb-0" ! for "Free Software" $ a ! class_ "nav-link btn btn-sm" $ "Free Software"
    H.div ! class_ "page" ! A.id "fs" $ do
        H.div ! class_ "row" $ H.div ! class_ "col my-md-3" $ small "» Free Software"
        H.div ! class_ "row" $ H.div ! class_ "col-md-12 text-center" $ p "Some of the free software projects JolHarg Ltd has created or contributed to are:"
        {- H.div ! class_ "row" $ do
            renderCard $ fsCard {
                language = LangJS,
                
                    name = "jolharg"
                
                    desc =  "Website of JolHarg"
                   
                    licence = AGPL-3.0
                sourceUrl = "https://github.com/JolHarg/jolharg.git"
                siteUrl = "https://jolharg.com"
            renderCard $ fsCard {
                language = LangJS,
                name = "projects"
                    stars = 1
                
                    desc =  "Random projects in random languages"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/projects.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "omegcli"
                    stars = 1
                
                    desc =  "Omegle CLI client for Node"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/omegcli.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "patchdeck"
                
                    desc =  "Audio patch deck in JS"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/patchdeck.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "zepper"
                
                    desc =  "Page grouping tool"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/zepper.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "vidsort"
                
                    desc =  "A video sorting tool for YouTube"
                   
                    licence = AGPL-3.0
                sourceUrl = "https://github.com/danwdart/vidsort.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "fsm"
                
                    desc =  "Finite State Machine. Touch his noodly appendage."
                   
                    licence = Unlicense
                sourceUrl = "https://github.com/danwdart/fsm.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "avia"
                
                    desc =  "Source for \"No It Isn't Bot\" and others"
                   
                    licence = Unlicense
                sourceUrl = "https://github.com/danwdart/avia.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "4letters"
                
                    desc =  "Inspired by Matt Parker/standupmaths"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/4letters.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "drpl"
                
                    desc =  "Dan's Reverse Polish Language"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/drpl.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "oeis"
                    stars = 1
                
                    desc =  "OEIS for Node.js"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/oeis.git"
            renderCard $ fsCard {
                language = LangHTML
                name = "dandart"
                
                    desc =  "Personal website"
                   
                    licence = AGPL-3.0
                sourceUrl = "https://github.com/danwdart/dandart.git"
                siteUrl = "https://dandart.co.uk"
            renderCard $ fsCard {
                language = LangHTML
                name = "jolharg-theme"
                
                    desc =  "(no description)"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/jolharg-theme.git"
            renderCard $ fsCard {
                language = LangHTML
                name = "lets-get-arrested"
                    isFork = true
                
                    desc =  "This project is intended to protest against the police in Japan"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/lets-get-arrested.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "heartish"
                
                    desc =  "circles and lines and shiz you know"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/heartish.git"
            renderCard $ fsCard {
                language = LangPHP
                name = "projectchaplin"
                    stars = 16
                
                    desc =  "Free and Open Source Video Sharing Platform"
                   
                    licence = AGPL-3.0
                sourceUrl = "https://github.com/danwdart/projectchaplin.git"
            renderCard $ fsCard {
                language = LangHTML
                name = "retroradio"
                
                    desc =  "A radio controller that runs in many different contexts"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/retroradio.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "pcomm"
                
                    desc =  "Portable Communicator"
                   
                    licence = AGPL-3.0
                sourceUrl = "https://github.com/danwdart/pcomm.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "simple-imap-inbox"
                    isFork = true
                
                    desc =  "Simple IMAP inbox with watch functionality"
                   
                    licence = MIT
                sourceUrl = "https://github.com/danwdart/simple-imap-inbox.git"
            renderCard $ fsCard {
                language = LangHTML
                name = "VypZZ"
                
                    desc =  "Text editor in HTML5 with syntax highlighting, tree view, snippets and git."
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/VypZZ.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "npm-expansions"
                    isFork = true
                
                    desc =  "Send us a pull request by editing expansions.txt"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/npm-expansions.git"
                siteUrl = "http://npm.im/npm-expansions"
            renderCard $ fsCard {
                language = LangTS
                name = "arsebeatfish"
                
                    desc =  "Backend as a service, API for SPAs, etc."
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/arsebeatfish.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "vinski2"
                
                    desc =  "Long awaited sequel of the original Vinski"
                   
                    licence = AGPL-3.0
                sourceUrl = "https://github.com/danwdart/vinski2.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "kallistarvin"
                
                    desc =  "discordant gaming bot in node"
                   
                    licence = AGPL-3.0
                sourceUrl = "https://github.com/danwdart/kallistarvin.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "secant"
                
                    desc =  "angular2 learning"
                   
                    licence = Unlicense
                sourceUrl = "https://github.com/danwdart/secant.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "todoapp"
                
                    desc =  "TODO app in Angular for code challenge"
                   
                    licence = Unlicense
                sourceUrl = "https://github.com/danwdart/todoapp.git"
            renderCard $ fsCard {
                language = LangTS
                name = "haber"
                
                    desc =  "react learning"
                   
                    licence = Unlicense
                sourceUrl = "https://github.com/danwdart/haber.git"
            renderCard $ fsCard {
                language = LangCoffee
                name = "dartcomm"
                
                    desc =  "Communicate all of the things!"
                   
                    licence = AGPL-3.0
                sourceUrl = "https://github.com/danwdart/dartcomm.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "autosnope"
                
                    desc =  "Browser extension for adding Snopes to social sharing websites"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/autosnope.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "Dan-cockatiel123"
                    isFork = true
                
                    desc =  "(no description)"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/Dan-cockatiel123.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "passport-oauth-example"
                
                    desc =  "(no description)"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/passport-oauth-example.git"
            renderCard $ fsCard {
                language = LangShell
                name = "update-checker"
                
                    desc =  "Checks various distributions' repositories for a few packages updates"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/update-checker.git"
            renderCard $ fsCard {
                language = LangPHP
                name = "zetabud"
                    stars = 1
                
                    desc =  "Bibud in Zend"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/zetabud.git"
            renderCard $ fsCard {
                language = LangPHP
                name = "widgeter"
                
                    desc =  "Widget console"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/widgeter.git"
            renderCard $ fsCard {
                language = LangPHP
                name = "sesite"
                
                    desc =  "Silent Echoes Website (2006-11-25 to 2007-04-06)"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/sesite.git"
            renderCard $ fsCard {
                language = LangPHP
                name = "ShareAV"
                
                    desc =  "Something I made once. Kind of what Project Chaplin turned into"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/ShareAV.git"
            renderCard $ fsCard {
                language = Nothing
                name = "nostalgia"
                
                    desc =  "(no description)"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/nostalgia.git"
            renderCard $ fsCard {
                language = LangPHP
                name = "Bibud"
                    stars = 4
                
                    desc =  "Bibud Social Web Desktop"
                   
                    licence = NOASSERTION
                sourceUrl = "https://github.com/danwdart/Bibud.git"
                siteUrl = "bibud.com"
            renderCard $ fsCard {
                language = LangPHP
                name = "betabud"
                    stars = 1
                
                    desc =  "The next generation of Bibud"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/betabud.git"
            renderCard $ fsCard {
                language = Nothing
                name = "danos64"
                
                    desc =  "(no description)"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/danos64.git"
            renderCard $ fsCard {
                language = Nothing
                name = "dotfiles"
                
                    desc =  "My ~/.*"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/dotfiles.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "serverless-prs-github"
                
                    desc =  "(no description)"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/serverless-prs-github.git"
            renderCard $ fsCard {
                language = Nothing
                name = "sanitos"
                
                    desc =  "Sane operating system distribution"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/sanitos.git"
            renderCard $ fsCard {
                language = LangPython
                name = "easylist"
                    isFork = true
                
                    desc =  "EasyList filter subscription"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/easylist.git"
            renderCard $ fsCard {
                language = LangPython
                name = "AdguardDNS"
                    isFork = true
                
                    desc =  "(no description)"
                   
                    licence = GPL-3.0
                sourceUrl = "https://github.com/danwdart/AdguardDNS.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "anglo"
                
                    desc =  "Dumb wordoid generator in Node"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/anglo.git"
            renderCard $ fsCard {
                language = LangShell
                name = "install_everything"
                
                    desc =  "Script to run when I install a new OS"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/install_everything.git"
            renderCard $ fsCard {
                language = LangPHP
                name = "evilphp"
                
                    desc =  "Never do this."
                   
                    licence = Unlicense
                sourceUrl = "https://github.com/danwdart/evilphp.git"
            renderCard $ fsCard {
                language = Nothing
                name = "system"
                
                    desc =  "My /"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/system.git"
            renderCard $ fsCard {
                language = LangPHP
                name = "Zend-Mongo-Db"
                
                    desc =  "Mongo DB interface for the Zend framework"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/Zend-Mongo-Db.git"
            renderCard $ fsCard {
                language = LangPHP
                name = "wolframalphaphp"
                    isFork = true
                
                    desc =  "A PHP Wrapper for Wolfram|Alpha APIs (v2)."
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/wolframalphaphp.git"
            renderCard $ fsCard {
                language = Nothing
                name = "winspy"
                
                    desc =  "WinSpy - find product keys etc (2006-11-01)"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/winspy.git"
            renderCard $ fsCard {
                language = Nothing
                name = "webtex"
                
                    desc =  "Just a CSV of the official webtex - code to come (2006-09-11)"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/webtex.git"
            renderCard $ fsCard {
                language = LangBlitzBasic
                name = "vinski"
                
                    desc =  "Vinski - 2D 2-player platform game with mostly easter eggs (2005-12-10 and 2006-10-10)"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/vinski.git"
            renderCard $ fsCard {
                language = LangC
                name = "software-application-standard"
                
                    desc =  "Standards for software applications"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/software-application-standard.git"
                siteUrl = "https://github.com/dandart/software-application-standard/wiki/Software-Application-Standard"
            renderCard $ fsCard {
                language = Nothing
                name = "sevb"
                
                    desc =  "Silent Echoes Launcher - VB version (2006-11-01 to 2006-11-07)"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/sevb.git"
            renderCard $ fsCard {
                language = LangTcl
                name = "selaunch"
                
                    desc =  "Silent Echoes Launcher (2007-04-15)"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/selaunch.git"
            renderCard $ fsCard {
                language = LangShell
                name = "scrapepins"
                    stars = 1
                
                    desc =  "Pinterest scraper"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/scrapepins.git"
            renderCard $ fsCard {
                language = LangShell
                name = "scrapeda"
                    stars = 1
                
                    desc =  "Some shell scripts to download deviations from DeviantArt, ripped from my gists"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/scrapeda.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "scalr-phonegap"
                
                    desc =  "I'm going to attempt to make a little script runner in phonegap"
                   
                    licence = NOASSERTION
                sourceUrl = "https://github.com/danwdart/scalr-phonegap.git"
            renderCard $ fsCard {
                language = Nothing
                name = "rflvb"
                
                    desc =  "Red Fire Light Launcher in Visual Basic 6 (2005-01-26 to 2005-01-31)"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/rflvb.git"
            renderCard $ fsCard {
                language = LangShell
                name = "pooh"
                
                    desc =  "honeypot"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/pooh.git"
            renderCard $ fsCard {
                language = LangHTML
                name = "polypropene"
                
                    desc =  "Attempting to create a web component for bootstrap modals"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/polypropene.git"
            renderCard $ fsCard {
                language = LangPHP
                name = "php-socket"
                
                    desc =  "OOP socket support for PHP"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/php-socket.git"
            renderCard $ fsCard {
                language = LangPHP
                name = "php-async"
                
                    desc =  "Async methods for PHP"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/php-async.git"
            renderCard $ fsCard {
                language = LangPHP
                name = "multiorm"
                
                    desc =  "PHP ORM for SQL and MongoDB from Project Chaplin"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/multiorm.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "movesic"
                
                    desc =  "Webcam music"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/movesic.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "jsarm"
                
                    desc =  "ARM emulator in JS"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/jsarm.git"
            renderCard $ fsCard {
                language = LangHTML
                name = "js86"
                
                    desc =  "Javascript 8086 real mode interpreter"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/js86.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "jammin"
                
                    desc =  "Jamendo API based music streamer for the web"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/jammin.git"
            renderCard $ fsCard {
                language = LangGNU
                name = "gwallgofrwydd"
                
                    desc =  "Some Linux, some gnu, some other stuff, you know how it is..."
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/gwallgofrwydd.git"
            renderCard $ fsCard {
                language = LangCoffee
                name = "gravity"
                
                    desc =  "Set of gravity simulators for the web"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/gravity.git"
            renderCard $ fsCard {
                language = LangPython
                name = "gmailfs"
                
                    desc =  "gmailfs imap version from git://git.sr71.net/gmailfs.git"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/gmailfs.git"
            renderCard $ fsCard {
                language = LangShell
                name = "glitcher"
                
                    desc =  "Creates animated glitchy versions of images"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/glitcher.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "freespeech"
                    stars = 1
                
                    desc =  "Free Speech"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/freespeech.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "fps"
                
                    desc =  "Set of 3D simulations, aspiring to become an FPS"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/fps.git"
            renderCard $ fsCard {
                language = LangPHP
                name = "form"
                
                    desc =  "Dan Forms, an OOP way to render forms and other HTML elements."
                   
                    licence = MIT
                sourceUrl = "https://github.com/danwdart/form.git"
            renderCard $ fsCard {
                language = LangHTML
                name = "equationsounds"
                
                    desc =  "Sounds generated by equations."
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/equationsounds.git"
            renderCard $ fsCard {
                language = Nothing
                name = "dockers"
                
                    desc =  "My useful docker containers"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/dockers.git"
            renderCard $ fsCard {
                language = LangC
                name = "danos32"
                
                    desc =  "A 32 bit version of DanOS for hobby purposes"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/danos32.git"
            renderCard $ fsCard {
                language = LangASM
                name = "danos"
                    stars = 1
                
                    desc =  "DanOS: A little learning operating system for x86 BIOS"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/danos.git"
            renderCard $ fsCard {
                language = LangCPP
                name = "cricket"
                
                    desc =  "Plays cricket with input stream."
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/cricket.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "btreesols"
                
                    desc =  "Solutions for a binary tree challenge"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/btreesols.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "bev"
                
                    desc =  "birds' eye view (game type thing)"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/bev.git"
            renderCard $ fsCard {
                language = LangShell
                name = "autopache"
                    stars = 4
                
                    desc =  "Autopache: Automatically setup Apache vhosts"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/autopache.git"
            renderCard $ fsCard {
                language = LangPHP
                name = "amqp"
                    stars = 3
                
                    desc =  "A PHP proxy used for dependency injection and testing Amqp applications."
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/amqp.git"
            renderCard $ fsCard {
                language = LangCPP
                name = "amarok"
                
                    desc =  "Audio player for KDE"
                   
                    licence = NOASSERTION
                sourceUrl = "https://github.com/danwdart/amarok.git"
            renderCard $ fsCard {
                language = LangC
                name = "ddate"
                    isFork = true
                
                    desc =  "The ddate source ripped out of util-linux"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/ddate.git"
            renderCard $ fsCard {
                language = LangJS,
                name = "ESideas"
                    isFork = true
                
                    desc =  "Notes and proposals on possible EMAScript extensions"
                   
                    licence = CC0-1.0
                sourceUrl = "https://github.com/danwdart/ESideas.git"
            renderCard $ fsCard {
                language = LangHTML
                name = "rigctl-Webinterface"
                    isFork = true
                
                    desc =  "rigctl Webinterface for Raspberry Pi"
                   
                    licence = Nothing
                sourceUrl = "https://github.com/danwdart/rigctl-Webinterface.git"
            -}

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

htmlHeader :: Html
htmlHeader = H.header $ nav ! class_ "p-0 p-sm-2 navbar d-block d-sm-flex navbar-expand navbar-dark bg-primary" $ do
    a ! class_ "w-75 p-0 pt-1 pt-sm-0 w-sm-auto text-center text-sm-left navbar-brand" ! href "" $ img ! src "/img/jolharg.png" ! A.style "height:32px" ! alt ""
    H.div $ ul ! class_ "navbar-nav px-3" $ do
        pagePortfolio
        --  +menuitem('Technologies')
        --    include ../pages/techs
        pageFs
        --  +menuitem('Pricing')
        --    include ../pages/pricing
        --  +menuitem('Blog')
        --    include ../pages/blog
        --  +menuitem('About')
        --    include ../pages/about
        pageContact

page :: Html
page = docTypeHtml ! lang "en-GB" $ do
    htmlHead descTitle keywords
    htmlHeader