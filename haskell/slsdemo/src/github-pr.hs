{-# LANGUAGE UnicodeSyntax  #-}
import           AWSLambda
import           AWSLambda.Events.APIGateway
import           Control.Lens
import           Data.Aeson
import           Data.Aeson.Embedded
import qualified Data.ByteString.Lazy.Char8  as BSL
import           Data.Map
import qualified Data.Text                   as T
import           GHC.Generics
import           System.Environment

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
