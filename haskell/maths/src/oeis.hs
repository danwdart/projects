{-# LANGUAGE DerivingVia    #-}
{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Control.Monad.IO.Class
import Data.Aeson
-- import Data.Aeson.Encode.Pretty
-- import Data.ByteString.Lazy.Char8 qualified as BSL
import GHC.Generics
import Network.HTTP.Req
import Text.PrettyPrint.GenericPretty

data OEISResult = OEISResult {
    _time        :: String,
    _offset      :: String,
    _references  :: Int,
    _data        :: String,
    _created     :: String,
    _link        :: [String],
    _example     :: Maybe [String],
    _reference   :: Maybe [String],
    _mathematica :: [String],
    _formula     :: Maybe [String],
    _xref        :: [String],
    _program     :: Maybe [String],
    _name        :: String,
    _author      :: String,
    _number      :: Int,
    _comment     :: Maybe [String],
    _revision    :: Int,
    _ext         :: Maybe [String],
    _keyword     :: String
}
    deriving stock (Eq, Generic, Show)

instance Out OEISResult

instance FromJSON OEISResult where
    parseJSON = genericParseJSON $ defaultOptions { fieldLabelModifier = drop 1 }

newtype OEISResponse = OEISResponse {
    results :: [OEISResult]
} deriving stock (Eq, Generic, Show)
    deriving (FromJSON) via Generically OEISResponse

instance Out OEISResponse

-- debugJSON :: (MonadHttp m, MonadIO m) => JsonResponse Value -> m ()
-- debugJSON = liftIO . BSL.putStrLn . encodePretty . responseBody

-- debug :: (FromJSON a, Show a, MonadIO m, MonadHttp m) => JsonResponse a -> m ()
-- debug = liftIO . print . responseBody

debugPP ∷ (FromJSON a, Out a, MonadIO m) ⇒ JsonResponse a → m ()
debugPP = liftIO . pp . responseBody

reqMain ∷ (MonadHttp m) ⇒ m ()
reqMain = do
    resSearchBySequence <- req GET (https "oeis.org" /: "search") NoReqBody jsonResponse (
        queryParam "fmt" (Just ("json" :: String)) <>
        queryParam "q" (Just ("12,15,18" :: String)) <>
        queryParam "start" (Just ("1" :: String))
        )
    debugPP (resSearchBySequence :: JsonResponse OEISResponse)


main ∷ IO ()
main = runReq defaultHttpConfig reqMain
