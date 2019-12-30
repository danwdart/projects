{-# LANGUAGE OverloadedStrings #-}

module Html.DanDart.Index (page) where

import Data.DanDart

import Html.Common.Audio
import Html.Common.Head
import Html.Common.Link
import Html.Common.Shortcuts
import Html.Common.Social

import Text.Blaze.Html.Renderer.Utf8
import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A

pageIntro :: Html
pageIntro = li ! class_ "nav-item" $ do
    input ! type_ "radio" ! A.style "display:none" ! checked "checked" ! name "selected" ! A.id "Intro" ! value "Intro"
    H.label ! class_ "mb-0" ! for "Intro" $ a ! class_ "nav-link btn btn-sm" $ "Intro"
    H.div ! class_ "page" ! A.id "intro" $ do
        H.div ! class_ "row" $ H.div ! class_ "col my-md-3" $ small "» Intro"
        H.div ! class_ "row" $ H.div ! class_ "col-md-8 offset-md-2 py-3 mb-3 bg-light" $ do
            p "Hello, my name is Dan."
            p "I am a software engineer, mathematics lover, radio ham and musician."
            p $ do
                "I work remotely to care for my future wife,"
                extLink "http://tsumikimikan.com" "Tsumiki"
                "."
            p "I also enjoy discordant and nonsensical commentary."
            p "I can speak about maths, physics, computer science and linguistics at length."
            p "You can find out more by using the links at the top."

pageCharacters :: Html
pageCharacters = li ! class_ "nav-item" $ do
    input ! type_ "radio" ! A.style "display:none" ! name "selected" ! A.id "Characters" ! value "Characters"
    H.label ! class_ "mb-0" ! for "Characters" $ a ! class_ "nav-link btn btn-sm" $ "Characters"
    H.div ! class_ "page" ! A.id "characters" $ do
        H.div ! class_ "row" $ H.div ! class_ "col my-md-3" $ small "» Characters"
        H.div ! class_ "row" $ H.div ! class_ "col-md-8 offset-md-2 py-3 mb-3 bg-light" $ do
            p "Some of my favourite characters and characters that I identify with are:"
            ul $ mapM_ (\(fandom, fandomLink, characters) -> do
                "from"
                extLink fandomLink fandom
                ":"
                ul $ mapM_ (\(character, charLink, reason) -> li $ do
                        extLink charLink character
                        ", "
                        reason
                    ) characters
                ) favCharacters

pageFavourites :: Html
pageFavourites = li ! class_ "nav-item" $ do
    input ! type_ "radio" ! A.style "display:none" ! name "selected" ! A.id "Favourites" ! value "Favourites"
    H.label ! class_ "mb-0" ! for "Favourites" $ a ! class_ "nav-link btn btn-sm" $ "Favourites"
    H.div ! class_ "page" ! A.id "favs" $ do
        H.div ! class_ "row" $ H.div ! class_ "col my-md-3" $ small "» Favourites"
        H.div ! class_ "row" $ H.div ! class_ "col-md-8 offset-md-2 py-3 mb-3 bg-light" $ do
            p "Here is a list of some of my favourite things."
            p $ strong "YouTube channels"
            ul $ do
                li $ strong "Maths"
                ul $ do
                    li $ extLink (ytUser <> "numberphile") "Numberphile"
                    li $ extLink (ytChan <> "UC1_uAIS3r8Vu6JjXWvastJg") "Mathologer"
                li $ strong "Science"
                ul $ li $ extLink (ytUser <> "Vsauce") "Vsauce"
                li $ strong "Computer Science"
                ul $ li $ extLink (ytUser <> "Computerphile") "Computerphile"
                li $ strong "General Knowledge / Other"
                ul $ li $ extLink (ytChan <> "UC9pgQfOXRsp4UKrI8q0zjXQ") "Lindybeige"
            p $ do
                strong "TV shows/movies"
                "(I also have an"
                extLink "https://www.imdb.com/list/ls029966237/" "IMDB"
                "watchlist)"
            ul $ do
                li $ do
                    "The Hannibal film and TV series:"
                    ul $ do
                        li $ do
                            extLink (imdb <> "0091474") "Manhunter (1986)"
                            br
                            "(well, you know... it's got... Iron Butterfly? *shrug*)"
                        li $ extLink (imdb <> "0102926") "The Silence of the Lambs (1991)"
                        li $ extLink (imdb <> "0212985") "Hannibal (2001)"
                        li $ extLink (imdb <> "0289765") "Red Dragon (2002)"
                        li $ extLink (imdb <> "0367959") "Hannibal Rising (2007)"
                        li $ extLink (imdb <> "2243973") "Hannibal (TV series, 2013-)"
                li $ do
                    "Star Trek films and series:"
                    ul $ do
                        li $ extLink (imdb <> "0092007") "Star Trek IV: The Voyage Home (1986)"
                        li $ extLink (imdb <> "0117731") "Star Trek: First Contact (1996)"
                        li $ extLink (imdb <> "0092455") "Star Trek: The Next Generation (1987-1994)"
                li $ do
                    extLink (imdb <> "0056751") "Doctor Who (1963-)"
                    "(my favourite Doctor is Tom Baker)"
            p $ strong "Music"
            ul $ mapM_ (\(title, list) -> do
                title
                ul $ mapM_ li list
                ) musicList
            p $ strong "Musical styles"
            ul $ mapM_ li musicalStyles
            p $ strong "Games"
            ul $ do
                li $ extLink "http://www.idsoftware.com/en-gb" "Quake"
                li $ extLink "http://sauerbraten.org/" "Cube 2: Sauerbraten"
                li $ extLink (wikipedia <> "The_Elder_Scrolls_IV:_Oblivion") "The Elder Scrolls IV: Oblivion"
                li $ extLink "https://ddlc.moe/" "Doki Doki Literature Club"
                li $ do
                    extLink "https://danganronpa.us/" "Danganronpa"
                    "(no despair girls / hope side spoilers please!)"
            p $ strong "Coding language:"
            ul $ li $ do
                extLink "https://www.haskell.org/" "Haskell"
                "(it's epic and pure!)"
            p $ strong "Operating Systems"
            ul $ do
                li $ do
                    extLink "http://www.gnu.org/gnu/why-gnu-linux.en.html" "GNU/Linux"
                    ":"
                    extLink "http://kubuntu.org" "Kubuntu"
                li $ do
                    extLink (wikipedia <> "Blue_Screen_of_Death") "Windows"
                    ":"
                    extLink (wikipedia <> "Windows_98#Windows_98_Second_Edition") "98 SE"
                li $ do
                    "All-time:"
                    extLink "http://riscos.com/riscos/310/index.php" "RISC OS"

pageHamRadio :: Html
pageHamRadio = li ! class_ "nav-item" $ do
    input ! type_ "radio" ! A.style "display:none" ! name "selected" ! A.id "Ham Radio" ! value "Ham Radio"
    H.label ! class_ "mb-0" ! for "Ham Radio" $ a ! class_ "nav-link btn btn-sm" $ "Ham Radio"
    H.div ! class_ "page" ! A.id "ham" $ do
        H.div ! class_ "row" $ H.div ! class_ "col my-md-3" $ small "» Ham Radio"
        H.div ! class_ "row" $ H.div ! class_ "col-md-8 offset-md-2 py-3 bg-light" $ do
            p "I am a UK full-licenced radio amateur, and have been issued the callsign M0ORI."
            p $ do
                "My nearest radio club is"
                extLink "https://www.midsarc.org.uk/" "Mid-Somerset Amateur Radio Club"
                "."
            p "I own the following types of radio:"
            ul $ do
                li $ do
                    extLink "https://www.yaesu.com/indexVS.cfm?cmd=DisplayProducts&ProdCatID=102&encProdID=06014CD0AFA0702B25B12AB4DC9C0D27" "Yaesu FT-817"
                    "(5W, all-mode HF, VHF, UHF transceiver)"
                li $ do
                    extLink "https://baofengtech.com/uv82" "Baofeng UV-82"
                    "(5W, FM, VHF and UHF transceiver)"
                li $ do
                    extLink "http://www.uv3r.com/" "Baofeng UV-3R"
                    "(2W, FM, VHF and UHF transceiver)"
                li $ do
                    extLink "https://www.eham.net/reviews/detail/7627" "Tecsun PL-600"
                    "(HF receiver)"
            p "You may sometimes find me on:"
            ul $ do
                li "FM in mid-Somerset, UK (IO81)."
                li "PSK on usually 20m"
                li "JT modes on usually 20m"
            p $ extLink "https://www.qrzcq.com/call/M0ORI" "My QRZCQ page"

pageHealth :: Html
pageHealth = li ! class_ "nav-item" $ do
    input ! type_ "radio" ! A.style "display:none" ! name "selected" ! A.id "Health" ! value "Health"
    H.label ! class_ "mb-0" ! for "Health" $ a ! class_ "nav-link btn btn-sm" $ "Health"
    H.div ! class_ "page" ! A.id "health" $ do
        H.div ! class_ "row" $ H.div ! class_ "col my-md-3" $ small "» Health"
        H.div ! class_ "row" $ H.div ! class_ "col-md-8 offset-md-2 py-3 mb-3 bg-light" $ do
            p "Both my physical and mental health are very low at the moment, but I am always more than happy to talk about them."
            p "I think I'm addicted to caffeine, which I wouldn't recommend."
            p "I have been diagnosed with the following things, both physical and mental intermingling:"
            ul $ do
                li $ extLink (nhs <> "memory-loss-amnesia/") "short-term memory loss"
                li $ extLinkTitle (nhs <> "post-traumatic-stress-disorder-ptsd") "Post-traumatic Stress Disorder" "PTSD"
                li $ extLink (nhs <> "fibromyalgia") "Fibromyalgia"
                li $ extLink (nhs <> "autism") "Asperger's Syndrome"
                li $ extLink (nhs <> "attention-deficit-hyperactivity-disorder-adhd") "ADHD"
                li $ extLink (nhs <> "generalised-anxiety-disorder") "Anxiety"

pageMusic :: Html
pageMusic = li ! class_ "nav-item" $ do
    input ! type_ "radio" ! A.style "display:none" ! name "selected" ! A.id "Music" ! value "Music"
    H.label ! class_ "mb-0" ! for "Music" $ a ! class_ "nav-link btn btn-sm" $ "Music"
    H.div ! class_ "page" ! A.id "music" $ do
        H.div ! class_ "row" $ H.div ! class_ "col my-md-3" $ small "» Music"
        H.div ! class_ "row" $ H.div ! class_ "col-md-8 offset-md-2 py-3 bg-light" $ do
            p "I play the guitar, keyboard and synthesiser."
            p "I've created the following pieces of music/sound effects:"
            audioFile "Gothic Orchestra" "GothicOrchestra" "SatanicOrchestra"
            audioFile "Shall It Be" "ShallItBe" "ShallItBe"
            audioFile "Swim Deep (take 1)" "SwimDeepTake1" "SwimDeepTake1"

pageMaths :: Html
pageMaths = li ! class_ "nav-item" $ do
    input ! type_ "radio" ! A.style "display:none" ! name "selected" ! A.id "Maths" ! value "Maths"
    H.label ! class_ "mb-0" ! for "Maths" $ a ! class_ "nav-link btn btn-sm" $ "Maths"
    H.div ! class_ "page" ! A.id "maths" $ do
        H.div ! class_ "row" $ H.div ! class_ "col my-md-3" $ small "» Maths"
        H.div ! class_ "row" $ H.div ! class_ "col-md-8 offset-md-2 py-3 bg-light" $ do
            p "Mathematics has always been a great pastime for me."
            p $ do
                "I have invented quite a few visualisations and generators for several interesting pieces of mathematics, some of which you can see and try on repos like my projects repo on GitHub ("
                extLink (projectsSource <> "/haskell/maths/src") "Haskell examples"
                extLink (projectsSource <> "/js/maths") "JS examples"
                ")"
            p "Some web-based notable (read: working right now) examples are:"
            ul $ do
                li $ extLink (ghPagesProjects <> "js/maths/src/cfe/index.html") "Continued Fraction Expander"
                li $ do
                    "A set of gravity simulators:"
                    ul $ do
                        li $ extLink (ghPages <> "gravity/2/gravity.html") "Sun version (left click for planets, middle click for stars)"
                        li $ extLink (ghPages <> "gravity/4/gravity.html") "Black hole version"
                li $ extLink (ghPagesProjects <> "js/maths/src/cellautomata/") "Cell Automata"
                li $ do
                    extLink (ghPagesProjects <> "js/maths/src/graphAndSound/") "Graph and Sound Demos"
                    br
                    "(one of these is actually the answer similar to"
                    extLink (yt <> "zSL8asTgpzA") "the riddle"
                    "I posed on my YouTube channel)"
                li $ extLink (ghPagesProjects <> "js/rolling/") "Rolling Shutter effect example"
                li $ extLink (ghPages <> "heartish/cardint.html") "Interactive Cardioid (keyboard only)"
                li $ extLink (ghPages <> "heartish/card.html") "Random Cardioid"
                li $ extLink (ghPages <> "heartish/index.html") "Circle Reflection"
            p $ do
                "My approved"
                extLinkTitle "https://oeis.org" "Online Encyclopedia of Integer Sequences" "OEIS"
                "sequences are:"
            ul $ do
                li $ extLink (oeis <> "275124") "A275124: Multiples of 5 where Pisano periods of Fibonacci numbers A001175 and Lucas numbers A106291 agree."
                li $ extLink (oeis <> "275167") "A275167: Pisano periods of A275124."
                li $ extLink (oeis <> "308267") "A308267: Numbers which divide their Zeckendorffian format exactly."
                li $ extLink (oeis <> "309979") "A309979: Hash Parker numbers: Integers whose real 32nd root's first six nonzero digits (after the decimal point) rearranged in ascending order are equal to 234477."

pageAbout :: Html
pageAbout = li ! class_ "nav-item" $ do
    input ! type_ "radio" ! A.style "display:none" ! name "selected" ! A.id "About This Site" ! value "About This Site"
    H.label ! class_ "mb-0" ! for "About This Site" $ a ! class_ "nav-link btn btn-sm" $ "About This Site"
    H.div ! class_ "page" ! A.id "about" $ do
        H.div ! class_ "row" $ H.div ! class_ "col my-md-3" $ small "» About This Site"
        H.div ! class_ "row" $ H.div ! class_ "col-md-8 offset-md-2 py-3 bg-light" $ do
            p "This website entailed a few design and code decisions which I would like to explain."
            p mempty
            p $ do
                strong "The layout"
                "was based on Bootstrap. I kept the header component and chose to be without a footer component. The menus are actually a hack, such that the chosen menu item is linked to a hidden radio button which chose which sub-page to show, rather than using JS for the menu."
            p mempty
            p $ do
                strong "The code"
                "actually contains no client-side JS at all, therefore, also adding to the preference of more and more users these days to not have tracking. The website code is compiled using the Pug layout engine, and uploaded to GitHub Pages. It uses my custom website theme which is published under the JolHarg organisation."
            p mempty
            p $ do
                strong "The font choice"
                "was difficult to make, as I was (and am still not quite happy enough with it, and so therefore still am) looking for a suitable, free software natural sans-serif font style, which has the single-storey \"a\", non-looped \"g\", and the double-seriffed I and J amongst other things. For now I've settled on Caudex, which whilst it is still serif, seems to be the closest I've yet to come across."

pageSoftware :: Html
pageSoftware = li ! class_ "nav-item" $ a ! class_ "nav-link btn btn-sm" ! href "https://jolharg.com" ! target "_blank" $ "Software"

pageContact :: Html
pageContact = li ! class_ "nav-item" $ do
    input ! type_ "radio" ! A.style "display:none" ! name "selected" ! A.id "Contact" ! value "Contact"
    H.label ! class_ "mb-0" ! for "Contact" $ a ! class_ "nav-link btn btn-sm" $ "Contact"
    H.div ! class_ "page" ! A.id "contact" $ do
        H.div ! class_ "row" $ H.div ! class_ "col my-md-3" $ small "» Contact"
        H.div ! class_ "row" $ H.div ! class_ "col-lg-6 offset-lg-3 col-sm-12 col-md-12 col-xs-12 bg-light p-3 mb-3" $ do
            p "If you would like to contact Dan, please use this form:"
            H.form ! action "https://formspree.io/website@dandart.co.uk" ! method "post" $ do
                H.div ! class_ "form-group" $ do
                    H.label ! for "name" $ "Your name"
                    input ! class_ "form-control" ! A.id "name" ! type_ "text" ! placeholder "John Smith" ! name "name" ! autocomplete "name"
                H.div ! class_ "form-group" $ do
                    H.label ! for "email" $ "Your email"
                    input ! class_ "form-control" ! A.id "email" ! type_ "email" ! placeholder "john@smith.com" ! name "email" ! autocomplete "email"
                    small ! class_ "form-text text-muted" ! A.id "emailHelp" $ "I'll never share your email with anyone else."
                H.div ! class_ "form-group" $ do
                    H.label ! for "subject" $ "Summary"
                    input ! class_ "form-control" ! A.id "subject" ! type_ "text" ! placeholder "Greetings..." ! name "_subject"
                H.div ! class_ "form-group" $ do
                    H.label ! for "message" $ "Your message"
                    textarea ! class_ "form-control" ! A.id "message" ! placeholder "Hello!..." ! rows "10" ! name "message" $ mempty
                H.div ! class_ "form-group" $ input ! class_ "btn btn-primary" ! type_ "submit" ! value "Send"

socialIcons :: Html
socialIcons = H.div ! class_ "row social-row" $ H.div ! class_ "text-right social-inside" $ do
    --  630 on mobile
    socialIconB "https://blog.dandart.co.uk/" "Blogger" "blogger-b"
    socialIconB "https://joindiaspora.com/people/08b11e5f4fff2a8b" "Diaspora" "diaspora"
    -- +social('discord', 'Discord', 'url', 'black')
    -- +social-no('facebook', 'Facebook', 'url', 'black')
    --  +social('firefox
    socialIconS "mailto:website@dandart.co.uk" "Email" "envelope"
    socialIconB "https://github.com/danwdart" "GitHub" "github"
    -- +social-no('google', 'Google', 'url', 'black')
    socialIconB "https://news.ycombinator.com/user?id=dandart" "Hacker News" "hacker-news"
    socialIconB "https://www.hackerrank.com/dandart" "HackerRank" "hackerrank"
    socialIconB "https://www.imdb.com/user/ur81806610" "ImDB" "imdb"
    -- +social('instagram', 'Instagram', 'url', 'black')
    -- +social('keybase', 'Keybase', 'url', 'black')
    socialIconB "https://www.last.fm/user/DanDart" "Last.fm" "lastfm"
    socialIconB "https://www.linkedin.com/in/dandart" "LinkedIn" "linkedin"
    -- +social('linux', 'Linux', 'url', 'black')
    -- +social('microsoft', 'Microsoft', 'url', 'black')
    socialIconB "https://mix.com/dandart" "Mix" "mix"
    socialIconB "https://www.npmjs.com/~dandart" "npm" "npm"
    socialIconB "https://www.patreon.com/kathiedart" "Patreon" "patreon"
    socialIconB "https://my.playstation.com/profile/MeowzorFnord" "PlayStation" "playstation"
    -- +social-no('pinterest', 'Pinterest', 'url', 'black')
    -- +pump('url', 'black')
    -- +social('raspberry-pi', 'Raspberry PI', 'url', 'black')
    socialIconB "https://www.reddit.com/user/jolharg" "Reddit" "reddit"
    -- +social('skype', 'Skype', 'url', 'black')
    socialIconB "/img/snapcode.svg" "Snapchat" "snapchat"
    socialIconB "https://soundcloud.com/kathiedart" "SoundCloud" "soundcloud"
    -- +social('spotify', 'Spotify', 'url', 'black')
    socialIconB "https://stackoverflow.com/users/1764563/dan-dart" "Stack Overflow" "stack-overflow"
    socialIconB "https://steamcommunity.com/id/dandart" "Steam" "steam"
    socialIconB "https://floofyhacker.com" "Tumblr" "tumblr"
    -- +social-no('twitter', 'Twitter', 'url', 'black')
    -- +social('ubuntu', 'Ubuntu', 'url', 'black')
    -- +social-no('windows', 'Windows', 'url', 'black')
    socialIconB (ytChan <> "UCaHwNzu1IlQKWCQEXACflaw") "YouTube" "youtube"

htmlHeader :: Html
htmlHeader = nav ! class_ "p-0 p-sm-2 navbar d-block d-sm-flex navbar-expand navbar-dark bg-primary" $ do
    a ! class_ "w-25 p-0 pt-1 pt-sm-0 w-sm-auto text-center text-sm-left navbar-brand" ! href "#intro" $ do
        img ! src "/img/favicon.png" ! A.style "height:32px" ! alt ""
        H.span ! class_ "title ml-2" $ "Dan Dart"
    H.div $ do
        ul ! class_ "navbar-nav px-3" $ do
            pageIntro
            pageCharacters
            pageFavourites
            pageHamRadio
            pageHealth
            pageMusic
            pageMaths
            pageAbout
            pageSoftware
            pageContact
        socialIcons

page :: Html
page = docTypeHtml ! lang "en-GB" $ do
    htmlHead descTitle keywords
    htmlHeader