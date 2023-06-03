{-# LANGUAGE OverloadedStrings, Safe #-}

module Data.Code.Haskell.Func where

import Control.Category
import Control.Category.Cartesian
import Control.Category.Choice
import Control.Category.Cocartesian
import Control.Category.Numeric
import Control.Category.Primitive.Abstract
import Control.Category.Primitive.Console
import Control.Category.Strong
import Data.Render
import Data.String
import Data.Tuple.Triple
import Prelude hiding ((.), id)
import System.Process


data HSCode a b = HSCode String
    deriving (Eq, Show)

instance IsString (HSCode a b) where
    fromString = HSCode

instance Category HSCode where
    id = "id"
    HSCode a . HSCode b = HSCode $ "(" <> a <> " . " <> b <> ")"

instance Cartesian HSCode where
    copy = "(\\x -> (x, x))"
    consume = "(const ())"
    fst' = "fst"
    snd' = "snd"

instance Cocartesian HSCode where
    injectL = "Left"
    injectR = "Right"
    unify = "(\\case { Left a -> a; Right a -> a; })"
    tag = "(\\case { (False, a) -> Left a; (True, a) -> Right a; })"

instance Strong HSCode where
    first' (HSCode f) = HSCode $ "(Data.Bifunctor.first " <> f <> ")"
    second' (HSCode f) = HSCode $ "(Data.Bifunctor.second " <> f <> ")"

instance Choice HSCode where
    left' (HSCode f) = HSCode $ "(\\case { Left a -> Left (" <> f <> " a); Right a -> Right a; })"
    right' (HSCode f) = HSCode $ "(\\case { Left a -> Left a; Right a -> Right (" <> f <> " a); })"

-- instance Symmetric HSCode where

-- instance Cochoice HSCode where

-- instance Costrong HSCode where

-- instance Apply HSCode where

instance Primitive HSCode where
    eq = "(arr . uncurry $ (==))"
    reverseString = "(arr reverse)"

instance PrimitiveConsole HSCode where
    outputString = "(Kleisli putStrLn)"
    inputString = "(Kleisli (const getLine))"

instance Numeric HSCode where
    num n = HSCode $ "(const " <> show n <> ")"
    negate' = "negate"
    add = "(uncurry (+))"
    mult = "(uncurry (*))"
    div' = "(uncurry div)"
    mod' = "(uncurry mod)"


instance Render (HSCode a b) where
    render (HSCode f) = f

runInGHCiParamC :: (Show input, Read output) => HSCode input output -> input -> IO output
runInGHCiParamC cat param = read . secondOfThree <$> readProcessWithExitCode "ghci" ["-e", ":set -XLambdaCase", "-e", "import Control.Arrow", "-e", render cat <> " " <> show param] ""
