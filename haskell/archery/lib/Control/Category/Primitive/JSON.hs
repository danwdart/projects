{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Control.Category.Primitive.JSON where

import Control.Arrow    (Kleisli (..))
import Control.Category
import Data.Aeson
-- import  Data.ByteString.Char8 qualified as BS
-- import  Data.ByteString.Lazy.Char8 qualified as BSL
import Prelude          hiding (id, (.))

class JSONIO cat where
    jsonToJSON :: (FromJSON a, ToJSON b) ⇒ cat a b → cat () ()

pureToKleisli ∷ Applicative m ⇒ (a → b) → Kleisli m a b
pureToKleisli f = Kleisli (pure . f)

{-}
instance JSONIO (Kleisli IO) where
    jsonToJSON kamb = Kleisli putStr .
        pureToKleisli BSL.unpack .
        pureToKleisli encode .
        kamb .
        -- pureToKleisli (maybe Object id) .
        pureToKleisli decode .
        pureToKleisli BSL.pack .
        Kleisli (const getContents)
-}
