{-# LANGUAGE DerivingVia    #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-x-partial #-}

module Main (main) where

-- import Control.Monad
import Data.Maybe
--import Data.Foldable
import Control.Lens             ((.~), (?~), (^.))
import Data.Aeson               (FromJSON)
import Data.Aeson               qualified as A
-- import Data.Aeson.Types (parse)
import Data.ByteString          qualified as BS
import Data.ByteString.Lazy     qualified as BSL
import Data.Foldable
import Data.Function
import Data.Functor
import Data.Text                as T
import GHC.Generics
import Network.Google
import Network.Google.Auth
--import Network.Google.Env
import Network.Google.Prelude   (toHeader)
import Network.Google.Translate
-- import Network.Google.Types
import Network.HTTP.Req
import System.Environment
import System.IO

-- TODO either use the Google Req gen or make own

res ∷ AccessToken → [T.Text] → IO (Maybe TR)
res accessToken xs = req POST
    (https "translation.googleapis.com" /: "language" /: "translate" /: "v2")
    (ReqBodyBs (BSL.toStrict (A.encode (makeT xs))))
    jsonResponse
    (header "Authorization" ("Bearer " `BS.append` toHeader accessToken))
    <&> responseBody
    & runReq defaultHttpConfig

data TRT = TRT {
    model          :: String,
    translatedText :: String
}
    deriving stock (Generic, Show)
    deriving (FromJSON) via Generically TRT

newtype TRD = TRD {
    translations :: [TRT]
}
    deriving stock (Generic, Show)
    deriving (FromJSON) via Generically TRD

newtype TR = TR {
    _data :: TRD
} deriving stock (Generic, Show)

-- TODO: This is actually a setting for an options map tbh
instance FromJSON TR where
    -- Removes the _ from _data so that it can find the "data" key which I can't use here.
    parseJSON = A.genericParseJSON $ A.defaultOptions { A.fieldLabelModifier = Prelude.tail }

main ∷ IO ()
main = do
    lgr <- newLogger Trace stdout
    setEnv "GOOGLE_APPLICATION_CREDENTIALS" "./google.json"
    env <- newEnv <&> (envLogger .~ lgr) . (envScopes .~ cloudTranslationScope)
    accessToken <- retrieveTokenFromStore (env ^. envStore) lgr (env ^.envManager) <&> _tokenAccess

    myRes <- res accessToken stringsToTranslate :: IO (Maybe TR)

    traverse_ putStrLn (( <&> translatedText) (translations (_data (fromJust myRes))))

    --a <- runResourceT . runGoogle env $ send myR
    --print $ a
    --print $ a^.tlrTranslations

stringsToTranslate ∷ [T.Text]
stringsToTranslate =
    [ "aaaaaaaaaa aaaaaaaa aaaaaaa aaaaaa aaaaaaa aaaa aaaa aaa aaa aaaaa aaaaaa a a aa aaa aa aaaaaa aaa aa aaaaaaaaaaaaaaaaaaaaaa. aaaaaaaaaa aaaaaaa aaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa. . aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa. aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    , "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    , "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
    , "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii"
    , "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii"
    , "uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu"
    , "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee eeeeeeeeeee eeeeeeeeeeeeee"
    ]

makeT ∷ [T.Text] → TranslateTextRequest
makeT xs = translateTextRequest
    & ttrFormat ?~ "text"
    & ttrSource ?~ "so"
    & ttrTarget ?~ "en"
    & ttrModel ?~ "nmt"
    & ttrQ .~ xs

--myR :: TranslationsTranslate
--myR = myT & translationsTranslate & ttPp .~ True
