-- there's a rubbish version of Map here so ignore it please, it's just PoC
module Main where

import Control.Monad.Fix
import Data.Bifunctor
import Data.Maybe

-- >>> fixedMap
-- [("a","b"),("c","d"),("d","b")]
--
fixedMap :: [(String, String)]
fixedMap = fix $ \self -> [
    ("a", "b"),
    ("c", "d"),
    ("d", fromMaybe "nah" $ lookup "a" self)
    ]

-- this is like Control.Lens.?? apparently
implicit :: Functor f => f (a -> b) -> a -> f b
implicit = flip (fmap . flip id)

fixerImplicit :: Functor f => f (f b -> b) -> f b
-- fixerImplicit xs = fix (\f -> fmap ($ f) xs)
fixerImplicit = fix . implicit -- from pointfree.io

-- >>> fixedImplicitFakeMap
-- [("a","b"),("c","d"),("d","b")]
--
fixedImplicitFakeMap :: [(String, String)]
fixedImplicitFakeMap = fixerImplicit [
    const ("a", "b"),
    const ("c", "d"),
    ("d",) . fromMaybe "nah" . lookup "a"
    ]

-- >>> getList fixedImplicitMap
-- [("a","b"),("c","d"),("d","b")]
--
fixedImplicitMap :: Map String String
fixedImplicitMap = fixerImplicit . Map $ [
    ("a", const "b"),
    ("c", const "d"),
    ("d", fromMaybe "nah" . lookup "a" . getList)
    ]

newtype Map k v = Map {
    getList :: [(k, v)]
}

-- a bit like newtype's ala Map
upon :: ([(k, v1)] -> [(k, v2)]) -> Map k v1 -> Map k v2
upon f = Map . f . getList

instance Functor (Map k) where
    fmap = upon . fmap . second

main :: IO ()
main = do
    print fixedMap
    print fixedImplicitFakeMap
    print . getList $ fixedImplicitMap