{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo       #-}
{-# LANGUAGE UnicodeSyntax     #-}

import           Reflex.Dom
import           Reflex.Tags as T

main ∷ IO ()
main = mainWidgetWithHead (
    do
        title_ $ text "Hello World!"
        elAttr "meta" ("name" =: "shortcut-icon" <> "content" =: "sample.png") blank
    ) $ mdo
    h1_ $ text "Hi!"
    text "Hello, world!"
    elInput <- inputElement $ def & inputElementConfig_initialValue .~ "Hi!"
    dynText $ _inputElement_value elInput
    (elBtn, _) <- button' $ text "Click me!"
    let eClick = domEvent Click elBtn
    clicks <- count eClick
    display clicks
    section_ $ mdo
        p_ $ text "Section 1"
        br_ blank
        p_ $ mdo
            text "Your name is "
            dynText $ _inputElement_value dName
            text "!"
        dName <- label_ $ mdo
            text "Your Name: "
            inputElement $ def &
                initialAttributes .~ "placeholder" =: "John Smith"
        return ()
        h1_ $ do
            text "You have clicked "
            display clicks
            text " times!"
    section_ $ do
        h1_ $ text "Hello World."
        h2_ $ text "Something."
    (elBtn2, _) <- button' $ display eTogBtn
    let eBtnClick = domEvent Click elBtn2
    eTogBtn <- toggle False eBtnClick
    section_ $ do
        text "The button is "
        display eTogBtn
    section_ $ do
        text "The text is held at: "
        dHeld <- holdDyn "" $ gate (current eTogBtn) $ updated $ _inputElement_value elInput
        display dHeld
        text ". Toggle the button to enable live-updates."
    return ()
