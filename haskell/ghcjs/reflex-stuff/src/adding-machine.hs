{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE MonoLocalBinds #-}
{-# LANGUAGE OverloadedStrings         #-}
{-# LANGUAGE OverloadedLists         #-}
{-# LANGUAGE RecursiveDo         #-}
{-# OPTIONS_GHC -Wwarn #-}

import                     Data.Text as T -- it missed this
import                     Reflex.Dom

fullStop = Period -- what were they thinking?

numberKeys :: [[Key]]
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

btn :: MonadWidget t m => El t -> Int -> Int -> m (Event t Int)
btn main n p = mdo
    (btn, _) <- elDynAttr' "button" (fmap (
        \nPressed -> [
            (
                "style",
                "font-size: 50px; border-style: " <> if nPressed then "inset" else "outset"
            )
            ]
            ) dPressed
        ) . text . T.pack . show $ (n :: Int)
    
    let eClick = domEvent Click btn
    let eKeyDown = keydown ((!! p) . Prelude.head $ numberKeys) main

    dPressed <- toggle False $ leftmost [eClick, eKeyDown]

    pure $ (n * 10 ^ p :: Int) <$ leftmost [eClick, eKeyDown]

widget :: MonadWidget t m => m ()
widget = mdo
    -- Create an input event stream for the digit buttons
    (main, _) <- elAttr' "div" [("id", "main"), ("style", "width:100%; height:100%")] $ mdo
        let eEnterUp = "Enter Up" <$ keyup Enter main
        let eEnterDown = "Enter Down" <$ keydown KeyK main

        btnsPressed <- el "div" $ do
            ps <- mapM (\p -> el "div" $ do
                ns <- mapM (btn main p) (Prelude.reverse [1..9])
                pure $ leftmost ns
                ) (Prelude.reverse [1..4])
            pure $ leftmost ps

        currentValue <- foldDyn (+) 0 $ btnsPressed

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

main ∷ IO ()
main = mainWidget widget