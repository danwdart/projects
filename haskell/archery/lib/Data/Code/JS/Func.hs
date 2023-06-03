{-# LANGUAGE OverloadedStrings, Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Data.Code.JS.Func where

import Control.Category
import Control.Category.Cartesian
import Control.Category.Choice
import Control.Category.Cocartesian
import Control.Category.Numeric
import Control.Category.Primitive.Abstract
import Control.Category.Primitive.Console
import Control.Category.Strong
import Data.Aeson
import Data.ByteString.Lazy.Char8 qualified as BSL
import Data.Render
import Data.String
import Data.Tuple.Triple
import Prelude hiding ((.), id)
import System.Process


data JSCode a b = JSCode String
    deriving (Eq, Show)

instance IsString (JSCode a b) where
    fromString = JSCode

instance Category JSCode where
    id = "(x => x)"
    JSCode a . JSCode b = JSCode $ "(x => " <> a <> "(" <> b <> "(x)))"

instance Cartesian JSCode where
    copy = "(x => [x, x])"
    consume = "(x => null)"
    fst' = "(([x, _]) => x)"
    snd' = "(([_, y]) => y)"

instance Cocartesian JSCode where
    injectL = "(x => ({tag: 'left', value: x}))"
    injectR = "(x => ({tag: 'right', value: x}))"
    unify = "(x => x.value)"
    tag = "(([b, x]) => ({tag: b ? 'right' : 'left', value: x}))"

instance Strong JSCode where
    first' (JSCode f) = JSCode $ "(([x, y]) => [" <> f <> "(x), y])"
    second' (JSCode f) = JSCode $ "(([x, y]) => [x, " <> f <> "(y)])"

instance Choice JSCode where
    left' (JSCode f) = JSCode $ "(({tag, value}) => ({tag, value: tag === 'left' ? " <> f <> " (value) : value}))"
    right' (JSCode f) = JSCode $ "(({tag, value}) => ({tag, value: tag === 'right' ? " <> f <> " (value) : value}))"

-- instance Symmetric JSCode where

-- instance Cochoice JSCode where

-- instance Costrong JSCode where

-- instance Apply JSCode where

instance Primitive JSCode where
    eq = "(([x, y]) => x === y)"
    reverseString = "(x => x.split('').reverse().join(''))"

instance PrimitiveConsole JSCode where
    outputString = "console.log"
    inputString = "prompt"

instance Numeric JSCode where
    num n = JSCode $ "(_ => " <> show n <> ")"
    negate' = "(x => -x)"
    add = "(([x, y]) => x + y)"
    mult = "(([x, y]) => x * y)"
    div' = "(([x, y]) => x / y)"
    mod' = "(([x, y]) => x % y)"

instance Render (JSCode a b) where
    render (JSCode f) = f

runInNode :: (ToJSON input, FromJSON output) => JSCode input output -> input -> IO (Maybe output)
runInNode cat param = decode . BSL.pack . secondOfThree <$> readProcessWithExitCode "node" ["-e", "console.log(JSON.stringify(" <> render cat <> "(" <> BSL.unpack (encode param) <> ")))"] ""
