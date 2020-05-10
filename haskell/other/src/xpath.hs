{-# LANGUAGE OverloadedStrings #-}

import Data.Foldable.Safe
import Data.Functor
import Data.List
import Lib.XPath

html, xpath :: String
html = "<!doctype html><html><body><div><p>Text <img src=\"Foo\"/><img src=\"jim\"/></p></div></body></html>"
xpath = "//img/@src"

findImages :: String -> IO [String]
findImages = processXPath xpath

main :: IO ()
main = (findImages html <&> defaulting "No results" (intercalate ", ")) >>= putStrLn . ("Results: " ++)