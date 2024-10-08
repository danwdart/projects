{-# LANGUAGE JavaScriptFFI     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Unsafe            #-}
{-# OPTIONS_GHC -Wno-unused-imports -Wno-unused-top-binds #-}

module Main (main) where

{-
const doReplaceName = replacements.forEach(
    (v, k) => document.documentElement.innerHTML = document.documentElement.innerHTML.replace(new RegExp(k, 'g'), v));
const doReplaceTweets = twitterUr; === window.location.href ?
    [].forEach.call(document.querySelectorAll('.TweetTextSize'), p => p.innerHTML = tr) :
    () => {};
-}

import Data.Map      (Map)
import Data.Map      qualified as Map
import GHCJS.DOM
import GHCJS.DOM.Types
import Run
-- import JavaScript.Web. qualified


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

replaceNames ∷ JSM ()
replaceNames = undefined

replaceTweets ∷ JSM ()
replaceTweets = undefined

performReplacements ∷ JSM ()
performReplacements = do
    replaceNames
    replaceTweets

onLoad ∷ JSM () → JSM ()
onLoad _ = undefined

main ∷ IO ()
main = run $
    --js_log "Unfart initialised"
    onLoad performReplacements
    --js_log "Unfart finished"
