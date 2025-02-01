{-# LANGUAGE RecursiveDo #-}

module Main (main) where

import Data.Text  (Text)
import Data.Text  qualified as T
import Reflex
import Reflex.Dom

data AddingMachineEvent = DigitPressed Int
                        | ClearPressed
                        | PlusPressed

addDigit ∷ Int → Integer → Integer
addDigit d x = x * 10 + fromIntegral d

main ∷ IO ()
main = mainWidgetWithHead headElement bodyElement

headElement ∷ MonadWidget t m ⇒ m ()
headElement = el "title" $ text "Adding Machine"

bodyElement ∷ MonadWidget t m ⇒ m ()
bodyElement = do
  el "h1" $ text "Adding Machine"
  rec
    let digitEvents = leftmost [ DigitPressed <$> n | n <- [0..9] ]
        clearEvent = ClearPressed <$ clearButton
        sumEvents = PlusPressed <$ sumButton
        events = mergeWith (.) [ addDigit <$> digitEvents
                               , const 0 <$ clearEvent
                               , fmap (curry (+)) sumEvents
                               ]
        displayAttrs = constDyn ("style" =: "width: 200px")
        display = displayInput events
        clearButton = button "Clear"
        sumButton = button "+"
  el "div" $ do
    el "p" $ display displayAttrs
    el "p" $ do
      el "button" $ text "1"
      el "button" $ text "2"
      el "button" $ text "3"
      el "br" blank
      el "button" $ text "4"
      el "button" $ text "5"
      el "button" $ text "6"
      el "br" blank
      el "button" $ text "7"
      el "button" $ text "8"
      el "button" $ text "9"
      el "br" blank
      el "button" $ text "0"
      el "button" clearButton
      el "button" sumButton

displayInput ∷ MonadWidget t m ⇒ Event t Integer → m ()
displayInput events = do
  let initialValue = 0
      setInt = ("type" =: "number") <> ("step" =: "1")
      setMin = "min" =: "0"
      attrs = constDyn $ setInt <> setMin
  display events initialValue $ \x -> inputElement $ def & inputElementConfig_initialValue .~ T.show x
                                                           & inputElementConfig_setValue .~ fmap T.show events
