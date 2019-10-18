{-# LANGUAGE DeriveAnyClass, DeriveGeneric, LambdaCase, OverloadedStrings #-}
module Page.GitHub (Repo (..), Language (..), getRepos) where

import Control.Monad.IO.Class
import Data.Aeson
import Data.Text as T
import Debug.Trace
import Distribution.SPDX
import GHC.Generics
import Network.HTTP.Req
import System.Environment

data Language = LangJS 
    | LangHTML
    | LangPHP
    | LangASM
    | LangGNU
    | LangTS
    | LangCoffee
    | LangShell
    | LangGeneric
    | LangPython
    | LangBlitzBasic
    | LangC
    | LangTcl
    | LangCPP deriving (Eq, Generic, Show)

instance FromJSON Language where
    parseJSON (String a) = return $ case a of
        "JavaScript" -> LangJS
        otherwise -> LangGeneric

-- I need to make a newtype because I can't just decide to make instances
newtype Licence = Licence LicenseId deriving (Generic, Show)

instance FromJSON Licence where
    parseJSON (String a) = return $ Licence (read (T.unpack a) :: LicenseId)
    parseJSON (Object b) = return $ Licence $ (read $ (b .: "spdx_id" :: String) :: LicenseId)
    parseJSON Null = return $ Licence Unlicense
    parseJSON a = do
        traceShowM a
        fail $ "Don't know what to parse!: " ++ (show a)
        return $ Licence Unlicense

data Repo = Repo {
    name :: String,
    description :: String,
    language :: Language,
    source :: Maybe String,
    website :: Maybe String,
    license :: Licence,
    stars :: Int
} deriving (FromJSON, Generic, Show)

getRepos :: Text -> Req [Repo]
getRepos user = do
    githubAccessToken <- liftIO . getEnv $ "GITHUB_ACCESS_TOKEN" -- throws
    res <- req GET (https "api.github.com" /: "users" /: user /: "repos") NoReqBody jsonResponse (
        "per_page" =: ("100" :: Text) <>
        "sort" =: ("pushed" :: Text) <>
        "type" =: ("owner" :: Text) <>
        "direction" =: ("desc" :: Text) <>
        "access_token" =: githubAccessToken <>
        header "User-Agent" "Dan's Haskell Bot v1.0"
        )
    liftIO . print . responseBody $ res
    return $ responseBody res