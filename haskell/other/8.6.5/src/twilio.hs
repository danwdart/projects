{-# LANGUAGE OverloadedStrings #-}

import Control.Monad.IO.Class
import Data.Maybe
import qualified Data.Text as T
import Network.URI
import System.Environment
import Twilio
import Twilio.Calls

-- Polly.Brian-Neural

-- todo dimap text to text

main :: IO ()
main = do
    twilioNumber <- getEnv "TWILIO_NUMBER"
    myNumber <-  getEnv "CALL_NUMBER"
    runTwilio' (getEnv "TWILIO_ACCOUNT_SID") (getEnv "TWILIO_AUTH_TOKEN") $ do
        call <- post PostCalls {
            from = T.pack twilioNumber,
            to = T.pack myNumber,
            urlOrApplicationSID = Left (fromMaybe nullURI $ parseURI "http://demo.twilio.com/docs/classic.mp3"), -- "AP0cf583f8f5b0ecd1c0cc5410741908c0",
            method = Nothing,
            fallbackURL = Nothing,
            fallbackMethod = Nothing,
            statusCallback = Nothing,
            statusCallbackMethod = Nothing,
            sendDigits = Nothing,
            ifMachine = Nothing,
            timeout = Nothing,
            record = Nothing
        }
        liftIO $ print call