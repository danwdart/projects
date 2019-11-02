module Page.Utils (intercalateAttr) where

-- import Data.String
import Text.Blaze.Html5 as H hiding (main)
-- import Text.Blaze.Html5.Attributes as A

intercalateAttr :: AttributeValue -> [AttributeValue] -> AttributeValue
intercalateAttr x = foldl1 (\acc y -> acc <> x <> y)