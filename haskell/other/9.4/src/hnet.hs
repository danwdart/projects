{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wno-safe -Wno-unsafe #-}

module Main (main) where

import Network.HaskellNet.SMTP

main ∷ IO ()
main = pure ()

{-

doSMTP "aspmx.l.google.com" $ \conn ->
   sendPlainTextMail "tohnet@dandart.co.uk" "fromhnet@dandart.co.uk" "Greetings" "Greetings!!" conn

-}
