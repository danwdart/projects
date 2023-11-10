module Main (main) where

import AWSLambda
import Control.Lens
import Data.Aeson
import Data.Aeson.Embedded
import Data.Text           qualified as T
import System.Environment

main ∷ IO ()
main = apiGatewayMain handler

handler ∷ APIGatewayProxyRequest (Embedded Value) → IO (APIGatewayProxyResponse (Embedded Value))
handler request = do
  env <- getEnvironment
  putStrLn "This should go to logs"
  print $ request ^. requestBody
  pure $ responseOK &
    responseBody
    ?~
      Embedded
        (object $ fmap (\ (k, v) -> (T.pack k, String (T.pack v))) env)
