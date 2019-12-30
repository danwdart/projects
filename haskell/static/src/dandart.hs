{-# LANGUAGE OverloadedStrings #-}

import Html.DanDart.Index

import qualified Data.ByteString.Lazy.Char8 as BSL

import System.Directory

import Text.Blaze.Html.Renderer.Utf8

main :: IO ()
main = do
    createDirectoryIfMissing True ".sites/dandart"
    -- Copy all static files
    -- Build HTML
    BSL.writeFile ".sites/dandart/index.html" $ renderHtml page
    -- Build CSS?
    -- Deploy?