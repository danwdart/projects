{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UnicodeSyntax     #-}

import qualified Graphics.UI.Threepenny      as UI
import           Graphics.UI.Threepenny.Core

main ∷ IO ()
main = startGUI defaultConfig {jsAddr = Just "0.0.0.0"} setup

alert ∷ String → JSFunction ()
alert = ffi "alert(%1)"

consolelog ∷ String → JSFunction ()
consolelog = ffi "console.log(%1)"

setup ∷ Window → UI ()
setup w = do
    _ <- pure w # set title "Hi"

    eTitle <- UI.h1 #. "title"
        # set style [("color","grey")]
        # set text "Hello!"

    _ <- getBody w #+ [element eTitle]

    liftUI $ do
        runFunction $ alert "Hello World"
        runFunction $ consolelog "Hi Console!"

    pure ()
