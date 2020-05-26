{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo       #-}
{-# LANGUAGE UnicodeSyntax     #-}

import           Reflex.Dom
import Reflex.Tags as T

main ∷ IO ()
main = mainWidgetWithHead (
    do
        title_ $ text "Hello World!"
        elAttr "meta" ("name" =: "shortcut-icon" <> "content" =: "sample.png") blank
    ) $ mdo
    h1_ $ text "Hi!"
    text "Hello, world!"
    input <- inputElement $ def & inputElementConfig_initialValue .~ "Hi!"
    dynText $ _inputElement_value input
    (btn, _) <- button' $ text "Click me!"
    let clickEvt = domEvent Click btn
    clicks <- count clickEvt
    display clicks
    section_ $ mdo
        p_ $ text "Section 1"
        br_ blank
        p_ $ mdo
            text "Your name is "
            dynText $ _inputElement_value name
            text "!"
        name <- label_ $ mdo
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
    (btn2, _) <- button' $ display togBtn
    let btnClick = domEvent Click btn2
    togBtn <- toggle False btnClick
    text "The button is "
    display togBtn
    return ()