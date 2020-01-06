{-# LANGUAGE OverloadedStrings #-}

import Build.Utils

import qualified Data.ByteString.Lazy.Char8 as BSL

import Data.JolHarg

import Html.Common.Card
import Html.Common.GitHub
import Html.Common.Head

import Html.JolHarg.Index

import Network.HTTP.Req

import System.Directory
import System.Path

import Text.Blaze.Html.Renderer.Utf8
import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A

main :: IO ()
main = do
    reposDan <- runReq defaultHttpConfig $ getRepos "danwdart"
    reposJH <- runReq defaultHttpConfig $ getRepos "jolharg"
    copyDir "static/common" ".sites/jolharg"
    copyDir "static/jolharg" ".sites/jolharg"
    BSL.writeFile ".sites/jolharg/index.html" $ renderHtml $ page $ reposDan <> reposJH
    putStrLn "jolharg compiled."