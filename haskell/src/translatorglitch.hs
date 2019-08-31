{-# LANGUAGE DeriveAnyClass, DeriveGeneric, OverloadedStrings, TemplateHaskell #-}

import Control.Monad
import Data.Maybe
import Data.Foldable
import Control.Lens ((.~),(^.))
import qualified Data.Aeson as A
import Data.Aeson ((.:),(.=), FromJSON)
import Data.Aeson.Types (parse)
import qualified Data.ByteString as BS
import Data.Function
import Data.Functor
import Data.Text
import GHC.Generics
import Network.Google
import Network.Google.Auth
import Network.Google.Env
import Network.Google.Prelude (toHeader, toUrlPiece)
import Network.Google.Translate
import Network.Google.Types
import Network.HTTP.Req
import System.Environment
import System.IO

-- TODO either use the Google Req gen or make own

res :: AccessToken -> IO (Maybe A.Object)
res accessToken = req POST 
    (https "translation.googleapis.com" /: "language" /: "translate" /: "v2")
    (ReqBodyBs "{\"q\":[\"ts um ik im ik an is th eb es t\"],\"target\":\"so\",\"source\":\"en\",\"model\":\"nmt\"}")
    jsonResponse
    (header "Authorization" ("Bearer " `BS.append` (toHeader accessToken)))
    <&> responseBody
    & runReq defaultHttpConfig

collateResults :: A.Object -> [A.Object]
collateResults a = a & parse (.: "data")
    >>= parse (.: "translations")
    & fold

main = do
    lgr <- newLogger Trace stdout
    setEnv "GOOGLE_APPLICATION_CREDENTIALS" "./google.json"
    env <- newEnv <&> (envLogger .~ lgr) . (envScopes .~ cloudTranslationScope)
    accessToken <- retrieveTokenFromStore (env ^. envStore) lgr (env ^.envManager) <&> _tokenAccess 

    myRes <- res accessToken <&> fromJust

    print (myRes & collateResults <&> parse (.: "translatedText") <&> (\(A.Success a) -> a) :: [String])
    
    --a <- runResourceT . runGoogle env $ send myR
    --print $ a
    --print $ a^.tlrTranslations

myT :: TranslateTextRequest
myT = translateTextRequest & ttrFormat .~ Just "text" & ttrQ .~ ["hallo"] & ttrSource .~ (Just "de") & ttrTarget .~ (Just "en") & ttrModel .~ (Just "nmt")

myR :: TranslationsTranslate
myR = myT & translationsTranslate & ttPp .~ True