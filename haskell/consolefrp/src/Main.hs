{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where
import Graphics.Vty qualified as V
-- import Graphics.Vty.Input.Events qualified as VIE
import Reflex.Vty
-- import           Reflex.Vty.Host
-- import           Reflex.Vty.Widget

main ∷ IO ()
main = mainWidget $ do
    text "Hello World"
    text "How are you?"
    inp <- input
    pure . fforMaybe inp $ \case
        V.EvKey (V.KChar 'c') [V.MCtrl] -> Just ()
        _                               -> Nothing
