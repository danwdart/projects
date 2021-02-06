{-# LANGUAGE JavaScriptFFI     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UnicodeSyntax     #-}

{-
const doReplaceName = replacements.forEach(
    (v, k) => document.documentElement.innerHTML = document.documentElement.innerHTML.replace(new RegExp(k, 'g'), v));
const doReplaceTweets = twitterUr; === window.location.href ?
    [].forEach.call(document.querySelectorAll('.TweetTextSize'), p => p.innerHTML = tr) :
    () => {};
-}

import           Data.JSString ()
import           Data.Map      (Map)
import qualified Data.Map      as Map
import           GHCJS.Types
-- import qualified JavaScript.Web.


--foreign import javascript unsafe "console.log($1)" js_log :: JSString -> IO ()

twitterUrl ∷ String
twitterUrl = "https://twitter.com/realdonaldtrump"

tweetReplacements ∷ String
tweetReplacements = "Pfffffrt"

tweetLocations ∷ String
tweetLocations = ".TweetTextSize"

replacements ∷ Map String String
replacements = Map.fromList
    [("Donald John Trump", "Arsehole Rectum Fart")
    ,("Donald J. Trump", "Arsehole R. Fart")
    ,("Donald Trump", "Arsehole Fart")
    ,("Trump", "Fart")
    ]

replaceNames ∷ IO ()
replaceNames = undefined

replaceTweets ∷ IO ()
replaceTweets = undefined

performReplacements ∷ IO ()
performReplacements = do
    replaceNames
    replaceTweets

onLoad ∷ IO () → IO ()
onLoad action = undefined

main ∷ IO ()
main =
    --js_log "Unfart initialised"
    onLoad performReplacements
    --js_log "Unfart finished"
