{-
import qualified Data.Map as Map
import qualified Data.Set as Set

type TagName = String

type AttrName = String

type AttrVal = String

type Attrs = Map.Map AttrName AttrVal

data H = H {
    tagName :: TagName,
    attrs :: Attrs,
    children :: Set.Set H
} deriving (Eq, Ord)

addAttr :: AttrName -> AttrVal -> [String] -> [String]
addAttr n v a = (n ++ "=\"" ++ v ++ "\""):a

renderAttrs :: Attrs -> String
renderAttrs attrs = unwords (Map.foldrWithKey addAttr [] attrs)

addChild :: H -> [String] -> [String]
addChild h arr = arr:h

renderChildren :: Set.Set H -> String
renderChildren children = unwords (Set.foldr addChild [] children)

render :: H -> String
render h = "<" ++ tagName h ++ if null (attrs h) then "" else " " ++ renderAttrs (attrs h) ++ ">" ++ renderChildren (children h) ++ "</" ++ tagName h ++ ">"

h :: H
h = H "h1" (Map.fromList [("class", "myClass"),("id", "myId")]) (Set.fromList [
    "Some Data?"])

result :: String
result = render h

main :: IO ()
main = putStrLn result
-}
main = putStrLn "Hi"