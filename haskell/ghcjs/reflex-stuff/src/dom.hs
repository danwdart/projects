{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings         #-}
{-# LANGUAGE RecursiveDo               #-}
{-# OPTIONS_GHC -Wno-type-defaults #-}

import Reflex.Dom

main ∷ IO ()
main = mainWidgetWithHead (
    do
        el "title" $ text "Hello World!"
        elAttr "meta" ("name" =: "shortcut-icon" <> "content" =: "sample.png") blank
    ) $ mdo
    el "h1" $ text "Hi!"
    text "Hello, world!"
    elInput <- inputElement $ def & inputElementConfig_initialValue .~ "Hi!"
    dynText $ _inputElement_value elInput
    (elBtn, _) <- el' "button" $ text "Click me!"
    let eClick = domEvent Click elBtn
    clicks <- count eClick
    display clicks
    el "section" $ mdo
        el "p" $ text "Section 1"
        el "br" blank
        el "p" $ mdo
            text "Your name is "
            dynText $ _inputElement_value dName
            text "!"
        dName <- el "label" $ mdo
            text "Your Name: "
            inputElement $ def &
                initialAttributes .~ "placeholder" =: "John Smith"
        pure ()
        el "h1" $ do
            text "You have clicked "
            display clicks
            text " times!"
    el "section" $ do
        el "h1" $ text "Hello World."
        el "h2" $ text "Something."
    (elBtn2, _) <- el' "button" $ display eTogBtn
    let eBtnClick = domEvent Click elBtn2
    eTogBtn <- toggle False eBtnClick
    el "section" $ do
        text "The button is "
        display eTogBtn
    el "section" $ do
        text "The text is held at: "
        dHeld <- holdDyn "" . gate (current eTogBtn) . updated $ _inputElement_value elInput
        display dHeld
        text ". Toggle the button to enable live-updates."
    pure ()
