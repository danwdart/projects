{-# LANGUAGE OverloadedStrings #-}

module Page.Audio (audioFile) where

import Page.Link

-- import Data.String
import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A

audioFile :: Html -> AttributeValue -> AttributeValue -> Html
audioFile audioTitle oggFilename mp3Filename = H.div ! class_ "border m-3" $ do
    p ! class_ "m-3" $ strong audioTitle
    p $ do
        audio ! controls "" $ do
            source ! src ("/music/" <> oggFilename <> ".ogg")
            source ! src ("/music/" <> mp3Filename <> ".mp3")
        extLink ("/music/" <> oggFilename <> ".ogg") "OGG"
        extLink ("/music/" <> mp3Filename <> ".mp3") "MP3"