{-# LANGUAGE OverloadedStrings, TemplateHaskell #-}

import Control.Monad
import Control.Lens
import Data.Function
import Data.Text
import Network.Google
import Network.Google.Translate
import System.Environment
import System.IO

main :: IO ()
main = do
    lgr <- newLogger Trace stdout
    setEnv "GOOGLE_APPLICATION_CREDENTIALS" "./google.json"
    env <- newEnv <&> (envLogger .~ lgr) . (envScopes .~ cloudTranslationScope)
    putStrLn "Fine"
    a <- runResourceT . runGoogle env $ send myR
    print $ a
    print $ a^.tlrTranslations

myT :: TranslateTextRequest
myT = translateTextRequest & ttrFormat .~ Just "text" & ttrQ .~ ["hallo"] & ttrSource .~ (Just "de") & ttrTarget .~ (Just "en") & ttrModel .~ (Just "nmt")

myR :: TranslationsTranslate
myR = myT & translationsTranslate & ttPp .~ True