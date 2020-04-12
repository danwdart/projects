module Lib.XPath (processXPath, getMatches) where

-- import Control.Monad.IO.Class
import Data.Functor
import Data.Maybe
import Data.Tree.Class
import Text.XML.HXT.DOM.XmlNode
import Text.XML.HXT.Core (IOStateArrow, XmlTree, XmlTrees, no, readString, runX, withParseHTML, withWarnings, yes)
import Text.XML.HXT.XPath

xmlTree :: String -> IOStateArrow s b XmlTree
xmlTree = readString [withParseHTML yes, withWarnings no]

myParseXPath :: Monad m => String -> [XmlTree] -> m XmlTrees
myParseXPath xpath xs = return . getXPath xpath $ head xs

processXPath :: String -> String -> IO [String]
processXPath xpath html = runX (xmlTree html)
    >>= myParseXPath xpath
    <&> concatMap getChildren
    <&> fmap getNode
    <&> fmap getText
    <&> catMaybes

nToText :: (XmlNode a, Tree t1, Foldable t2) => t2 (t1 a) -> String
nToText x = concat $ mapMaybe (getText . getNode) (concatMap getChildren x)

getMatches :: String -> IO [(String, String)]
getMatches a = tail . fmap (\x -> (
    nToText $ getXPathSubTrees "//a[@class=\"detLink\"]" x,
    nToText $ getXPathSubTrees "//a[@title=\"Download this torrent using magnet\"]/@href" x
    )) . (concatMap . getXPath $ "//tr") <$> runX (xmlTree a)