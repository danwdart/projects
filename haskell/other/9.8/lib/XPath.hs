{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-x-partial #-}

module XPath (processXPath) where

import Data.Functor
import Data.Maybe
import Data.Tree.Class
import Text.XML.HXT.Core        (IOStateArrow, XmlTree, XmlTrees, no,
                                 readString, runX, withParseHTML, withWarnings,
                                 yes)
import Text.XML.HXT.DOM.XmlNode
import Text.XML.HXT.XPath

xmlTree ∷ String → IOStateArrow s b XmlTree
xmlTree = readString [withParseHTML yes, withWarnings no]

myParseXPath ∷ Monad m ⇒ String → [XmlTree] → m XmlTrees
myParseXPath xpath xs = pure . getXPath xpath $ head xs

processXPath ∷ String → String → IO [String]
processXPath xpath html = runX (xmlTree html) >>= myParseXPath xpath <&> concatMap getChildren <&> fmap getNode <&> fmap getText <&> catMaybes

-- processXPathMap :: String -> String -> (XmlTree -> a) -> IO [a]
-- processXPathMap xpath html fn =
