{-# LANGUAGE DeriveAnyClass, DeriveGeneric, OverloadedStrings #-}
module Page.GitHub (fetchRepos, Repo (..), Language (..), getRepos) where

import Control.Monad.IO.Class
import Data.Aeson
import Data.Text as T
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
    | LangCPP deriving (Eq, FromJSON, Generic, Show)

-- I need to make a newtype because I can't just decide to make instances
newtype Licence = Licence LicenseId deriving (Generic, Show)

instance FromJSON Licence where
    parseJSON (String a) = return $ Licence (read (T.unpack a) :: LicenseId)

data Repo = Repo {
    name :: String,
    description :: String,
    language :: Language,
    source :: String,
    website :: String,
    licence :: Licence,
    stars :: Int
} deriving (FromJSON, Generic, Show)

fetchRepos :: IO [Repo]
fetchRepos = undefined

getRepos :: Text -> Req [Repo]
getRepos user = do
    githubAccessToken <- liftIO . getEnv $ "GITHUB_ACCESS_TOKEN" -- throws
    res <- req GET (https "api.github.com" /: "users" /: user /: "repos") NoReqBody jsonResponse (
        "per_page" =: ("100" :: Text) <>
        "sort" =: ("pushed" :: Text) <>
        "type" =: ("owner" :: Text) <>
        "direction" =: ("desc" :: Text) <>
        "access_token" =: githubAccessToken
        )
    return $ responseBody res