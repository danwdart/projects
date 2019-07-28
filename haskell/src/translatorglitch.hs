{-# LANGUAGE OverloadedStrings, TemplateHaskell #-}

import Control.Monad
import Control.Lens
import Data.Function
import Network.Google
import Network.Google.Translate

main :: IO ()
main = undefined

myT :: TranslateTextRequest
myT = translateTextRequest & ttrFormat .~ Just "text" & ttrQ .~ ["ts um ik im ik an"] & ttrSource .~ (Just "so") & ttrTarget .~ (Just "en")

myR :: TranslationsTranslate
myR = myT & translationsTranslate & ttPp .~ True