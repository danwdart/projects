{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo       #-}
{-# OPTIONS_GHC -Wno-type-defaults -Wno-unused-local-binds -Wno-unused-top-binds #-}

module Main (main) where

import Clay           as C
import Data.Text
import Data.Text.Lazy (toStrict)
import Reflex.Dom

css ∷ Css
css = do
    star ? do
        padding nil nil nil nil
        margin nil nil nil nil
        borderWidth nil
        boxSizing borderBox
    body ? do
        backgroundColor white
    ".box" ? do
        C.display inlineBlock
        height (px 50)
        width (px 50)
        margin (px 2) (px 2) (px 2) (px 2)
        border solid (px 2) black
        fontSize (px 40)
        fontFamily [] [sansSerif]
        fontWeight bold
        textAlign C.center
        lineHeight (px 50)
    ".green" ? do
        color white
        backgroundColor green
    ".yellow" ? do
        color black
        backgroundColor yellow
    ".grey" ? do
        color white
        backgroundColor grey


greenBox ∷ (DomBuilder t m) ⇒ Text → m ()
greenBox = divClass "box green" . text

yellowBox ∷ (DomBuilder t m) ⇒ Text → m ()
yellowBox = divClass "box yellow" . text

greyBox ∷ (DomBuilder t m) ⇒ Text → m ()
greyBox = divClass "box grey" . text

main ∷ IO ()
main = mainWidgetWithHead (
    do
        el "title" $ text "Words Game"
        el "style" . text . toStrict . render $ css
        elAttr "meta" ("name" =: "shortcut-icon" <> "content" =: "sample.png") blank
    ) $ mdo
    box1 <- greenBox "A"
    box2 <- yellowBox "E"
    box3 <- greyBox "I"
    pure ()
