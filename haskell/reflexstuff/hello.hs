{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo       #-}
{-# LANGUAGE UnicodeSyntax     #-}

import           Reflex.Dom

main ∷ IO ()
main = mainWidgetWithHead (
    do
        el "title" $ text "Hello World!"
        elAttr "meta" ("name" =: "shortcut-icon" <> "content" =: "sample.png") blank
    ) $ do
    el "h1" $ text "Hi!"
    text "Hello, world!"
    input <- inputElement $ def & inputElementConfig_initialValue .~ "Hi!"
    dynText $ _inputElement_value input
    (btn, _) <- el' "button" $ text "Click me!"
    let clickEvt = domEvent Click btn
    clicks <- count clickEvt
    display clicks
    el "section" $ mdo
        el "p" $ text "Section 1"
        el "br" blank
        el "p" $ mdo
            text "Your name is "
            dynText $ _inputElement_value name
            text "!"
        name <- el "label" $ mdo
            text "Your Name: "
            inputElement $ def &
                initialAttributes .~ "placeholder" =: "John Smith"
        return ()
        el "h1" $ do
            text "You have clicked "
            display clicks
            text " times!"
    return ()
