{-# LANGUAGE OverloadedStrings #-}

import           Data.Foldable.Safe
import           Data.List
import           XPath

html, xpath ∷ String
html = "<!doctype html><html><body><div><p>Text <img src=\"Foo\"/><img src=\"jim\"/></p></div></body></html>"
xpath = "//img/@src"

findImages ∷ String → IO [String]
findImages = processXPath xpath

main ∷ IO ()
main = findImages html >>= (putStrLn . ("Results: " ++)) . defaulting "No results" (intercalate ", ")
