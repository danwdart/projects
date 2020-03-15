{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString.Lazy.Char8 as BSL
import System.Environment
import System.Path
import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.Utf8

main :: IO ()
main = do
    -- Copy all static files
    copyDir "static" "public"
    -- Build HTML
    env <- getEnvironment
    BSL.writeFile "public/index.html" $ renderHtml $ page env

page :: [(String, String)] -> Html
page env = docTypeHtml ! lang "en-GB" $ do
    H.html $
        H.head $
            H.title "Test"
    H.body $ do
        H.h1 "Test"
        H.ul $ mapM_ (\(key, value) -> H.li $ do
            strong (string key)
            string ": "
            string value
            ) env