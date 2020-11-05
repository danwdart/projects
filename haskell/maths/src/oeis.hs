{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UnicodeSyntax     #-}

import           Control.Monad.IO.Class
import           Data.Aeson
-- import Data.Aeson.Encode.Pretty
-- import qualified Data.ByteString.Lazy.Char8 as BSL
import           Network.HTTP.Req
import           Text.PrettyPrint.GenericPretty

data OEISResult = OEISResult {
    _time :: String,
    _offset :: String,
    _references :: Int,
    _data :: String,
    _created :: String,
    _link :: [String],
    _example :: Maybe [String],
    _reference :: Maybe [String],
    _mathematica :: [String],
    _formula :: Maybe [String],
    _xref :: [String],
    _program :: Maybe [String],
    _name :: String,
    _author :: String,
    _number :: Int,
    _comment :: Maybe [String],
    _revision :: Int,
    _ext :: Maybe [String],
    _keyword :: String
} deriving (Eq, Generic, Out, Show)

instance FromJSON OEISResult where
    parseJSON = genericParseJSON $ defaultOptions { fieldLabelModifier = tail }

newtype OEISResponse = OEISResponse {
    results :: [OEISResult]
} deriving (Eq, FromJSON, Generic, Out, Show)

-- debugJSON :: JsonResponse Value -> Req ()
-- debugJSON = liftIO . BSL.putStrLn . encodePretty . responseBody

-- debug :: (FromJSON a, Show a) => JsonResponse a -> Req ()
-- debug = liftIO . print . responseBody

debugPP ∷ (FromJSON a, Out a) ⇒ JsonResponse a → Req ()
debugPP = liftIO . pp . responseBody

reqMain ∷ Req ()
reqMain = do
    resSearchBySequence <- req GET (https "oeis.org" /: "search") NoReqBody jsonResponse (
        queryParam "fmt" (Just ("json" :: String)) <>
        queryParam "q" (Just ("12,15,18" :: String)) <>
        queryParam "start" (Just ("1" :: String))
        )
    debugPP (resSearchBySequence :: JsonResponse OEISResponse)


main ∷ IO ()
main = runReq defaultHttpConfig reqMain
