{-# LANGUAGE DeriveAnyClass, DeriveGeneric #-}
import AWSLambda
import AWSLambda.Events.APIGateway
import Control.Lens
import Data.Aeson
import Data.Aeson.Embedded
import Data.Map
import GHC.Generics
import qualified Data.ByteString.Lazy.Char8 as BSL
-- import Data.Text

main :: IO ()
main = apiGatewayMain handler

handler :: APIGatewayProxyRequest (Embedded Value) -> IO (APIGatewayProxyResponse String)
handler request = do
  putStrLn "This should go to logs"
  print $ request ^. requestBody
  pure $ responseOK & responseBody ?~ "{\"Airse\":\"Baulacks\"}"