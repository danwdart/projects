{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings         #-}
{-# LANGUAGE OverloadedLists         #-}
{-# LANGUAGE GADTs         #-}
{-# LANGUAGE RecursiveDo         #-}
{-# OPTIONS_GHC -Wwarn #-}

import                     Data.Text as T -- it missed this
import                     Reflex.Dom

fullStop = Period -- what were they thinking?

numberKeys = [
    [
        fullStop,
        Comma,
        KeyM,
        KeyN,
        KeyB,
        KeyV,
        KeyC,
        KeyX,
        KeyZ
    ],
    [
        KeyL,
        KeyK,
        KeyJ,
        KeyH,
        KeyG,
        KeyF,
        KeyD,
        KeyS,
        KeyA
    ],
    [
        KeyO,
        KeyI,
        KeyU,
        KeyY,
        KeyT,
        KeyR,
        KeyE,
        KeyW,
        KeyQ
    ],
    [
        Digit9,
        Digit8,
        Digit7,
        Digit6,
        Digit5,
        Digit4,
        Digit3,
        Digit2,
        Digit1
    ]
    ]

data CountingMode = ToggleCranked | AutomaticKeying

main ∷ IO ()
main = mainWidget $ mdo
    -- Create an input event stream for the digit buttons
    (main, _) <- elAttr' "div" [("id", "main"), ("style", "width:100%; height:100%")] $ mdo
        let eEnterUp = "Enter Up" <$ keyup Enter main
        let eEnterDown = "Enter Down" <$ keydown KeyK main

        btnsPressed <- el "div" $ do

            el "div" $ mapM (\p -> mdo
                (btn, _) <- elDynAttr' "button" (fmap (
                    \nPressed -> [
                        (
                            "style",
                            "font-size: 50px; border-style: " <> if nPressed then "inset" else "outset"
                        )
                        ]
                        ) dPressed
                    ) . text . T.pack . show $ (2 :: Int)

                dPressed <- toggle False $ leftmost [domEvent Click btn, keydown ((!! p) . Prelude.head $ numberKeys) main]

                pure $ (2 * 10 ^ p :: Int) <$ leftmost [domEvent Click btn, keydown ((!! p) . Prelude.head $ numberKeys) main]
            ) (Prelude.reverse [1..9])

            

            el "div" $ mapM (\p -> mdo
                (btn, _) <- elDynAttr' "button" (fmap (
                    \nPressed -> [
                        (
                            "style",
                            "font-size: 50px; border-style: " <> if nPressed then "inset" else "outset"
                        )
                        ]
                        ) dPressed
                    ) . text . T.pack . show $ (1 :: Int)

                dPressed <- toggle False $ leftmost [domEvent Click btn, keydown ((!! p) . Prelude.head $ numberKeys) main]

                pure $ (1 * 10 ^ p :: Int) <$ leftmost [domEvent Click btn, keydown ((!! p) . Prelude.head $ numberKeys) main]
            ) (Prelude.reverse [1..9])

        currentValue <- foldDyn (+) 0 $ leftmost btnsPressed

        {-}
        el "div" $ do
            text "The current value is: "
            display currentValue
        -}
        
        {-}
        mainRegister <- foldDyn (+) 0 currentValue

        el "div" $ do
            text "The value of the main register is: "
            display mainRegister
        -}

        crankButton <- button "Crank!"

        pure ()
    pure ()