{-# LANGUAGE Safe #-}

module Control.Category.Primitive.Stdio where

import Control.Arrow    (Kleisli (..))
import Control.Category
import Prelude          hiding (id, (.))

class Stdio cat where
    strToIO :: cat String String → cat () ()

instance Stdio (Kleisli IO) where
    strToIO kamb = Kleisli putStr . kamb . Kleisli (const getContents)
