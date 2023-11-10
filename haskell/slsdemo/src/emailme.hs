{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import AWSLambda
import Control.Lens
import Data.Aeson
import Data.Aeson.Embedded
import Data.Text           qualified as T
-- import           Network.AWS.SES
import System.Environment

main ∷ IO ()
main = apiGatewayMain handler

handler ∷ APIGatewayProxyRequest (Embedded Value) → IO (APIGatewayProxyResponse (Embedded Value))
handler request = do
  env <- getEnvironment
  putStrLn "This should go to logs"
  print $ request ^. requestBody
  {-
  let sre = sendRawEmail (rawMessage "Hello World") &
    sreDestinations .~ ["amazon@dandart.co.uk"] &
      sreSource ?~ "amazon@dandart.co.uk"
  -}
  pure $ responseOK &
    responseBody
    ?~
      Embedded
        (object $ fmap (\ (k, v) -> (T.pack k, String (T.pack v))) env)
