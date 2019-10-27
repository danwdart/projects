module Funk.Map (mapMap, mapMap2) where

import Data.Bifunctor
import Data.Map

mapMap :: Ord k2 => ((k1, a1) -> (k2, a2)) -> Map k1 a1 -> Map k2 a2
mapMap f = fromList . fmap f . toList

-- Inside like Relude.Extra.Bifunctor bimapF
mapMap2 :: Ord k => (t1 -> k) -> (t2 -> a) -> Map t1 t2 -> Map k a
mapMap2 f g = fromList . fmap (bimap f g) . toList