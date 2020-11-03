{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UnicodeSyntax     #-}

import           Network.HaskellNet.SMTP

main ∷ IO ()
main = doSMTP "aspmx.l.google.com" $ \conn ->
   sendPlainTextMail "tohnet@dandart.co.uk" "fromhnet@dandart.co.uk" "Greetings" "Greetings!!" conn
