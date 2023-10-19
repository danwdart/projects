{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo       #-}

import Control.Monad.Fix (MonadFix)
import Data.Text         (Text)
import Data.Text         qualified as T
import Reflex
import Reflex.Dom

data AddingMachineEvent = DigitPressed Int | ClearPressed

main ∷ IO ()
main = mainWidgetWithHead headElement bodyElement

headElement ∷ MonadWidget t m ⇒ m ()
headElement = el "head" $ do
  el "title" $ text "Adding Machine Simulator"
  el "style" $ text cssStyles

bodyElement ∷ MonadWidget t m ⇒ m ()
bodyElement = el "div" $ mdo
  -- create the register and display its value
  register <- foldDyn (+) 0 sumEvents
  display register

  -- create the clear button
  clearBtn <- button "Clear"
  let clearEvent = const 0 <$ clearBtn

  -- create the digit keys
  let digitButtons = fmap digitButton [0..9]
      digitButton n = button . T.pack $ show n
      digitEvents = leftmost (zipWith (<$) [0..9] digitButtons)

  -- combine the clear, digit, and sum events
  let allEvents = mergeWith (<$>) [clearEvent, fmap DigitPressed digitEvents, fmap (curry (+)) sumEvents]

  -- simulate the adding machine by accumulating events
  sumEvents <- accumDyn 0 $ handleEvent <$> allEvents

  pure ()

handleEvent ∷ AddingMachineEvent → (Dynamic t Integer, Dynamic t Text) → (Dynamic t Integer, Dynamic t Text)
handleEvent event (accumulator, display) =
  case event of
    DigitPressed digit -> (accumulator', display')
      where
        accumulator' = accumulator * 10 + fromIntegral digit
        display' = tshow accumulator'
    ClearPressed -> (pure 0, pure "0")
      where
        accumulator'' f acc display' = f acc (read . T.unpack $ display')

cssStyles ∷ Text
cssStyles = T.unlines
  [ "button {"
  , "  font-size: 20px;"
  , "  width: 40px;"
  , "  height: 40px;"
  , "  margin: 5px;"
  , "}"
  ]
