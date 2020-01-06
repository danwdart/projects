{-# LANGUAGE OverloadedStrings #-}

module Html.Common.Audio (audioFile) where

import Html.Common.Link

import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A

audioFile :: Html -> AttributeValue -> AttributeValue -> Html
audioFile audioTitle oggFilename mp3Filename = H.div ! class_ "border m-3" $ do
    p ! class_ "m-3" $ strong audioTitle
    p $ do
        audio ! controls "" $ do
            source ! src ("/music/" <> oggFilename <> ".ogg")
            source ! src ("/music/" <> mp3Filename <> ".mp3")
        extLink ("/music/" <> oggFilename <> ".ogg") $ H.span ! class_ "px-2" $ "OGG"
        extLink ("/music/" <> mp3Filename <> ".mp3") $ H.span ! class_ "px-2" $ "MP3"