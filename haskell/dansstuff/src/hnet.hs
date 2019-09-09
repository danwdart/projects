{-# LANGUAGE OverloadedStrings #-}

import Network.HaskellNet.Auth
import Network.HaskellNet.SMTP
import qualified Data.Text.Lazy as T

main :: IO ()
main = doSMTP "aspmx.l.google.com" $ \conn ->
   sendPlainTextMail "tohnet@dandart.co.uk" "fromhnet@dandart.co.uk" "Greetings" "Greetings!!" conn