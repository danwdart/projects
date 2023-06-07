{-# LANGUAGE OverloadedStrings, Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Data.Code.JS.Lamb where

import Control.Category
import Control.Category.Cartesian
import Control.Category.Choice
import Control.Category.Cocartesian
import Control.Category.Execute.JSON
import Control.Category.Execute.Stdio
import Control.Category.Numeric
import Control.Category.Primitive.Abstract
import Control.Category.Primitive.Console
import Control.Category.Strong
import Control.Category.Symmetric
import Control.Monad.IO.Class
import Data.Aeson
import Data.ByteString.Lazy.Char8 qualified as BSL
import Data.Render
import Data.String
import Data.Tuple.Triple
import Prelude hiding ((.), id)
import System.Process

data JSLamb a b = JSLamb String
    deriving (Eq, Show)

instance IsString (JSLamb a b) where
    fromString = JSLamb

instance Category JSLamb where
    id = "(x => x)"
    JSLamb a . JSLamb b = JSLamb $ "(x => " <> a <> "(" <> b <> "(x)))"

instance Cartesian JSLamb where
    copy = "(x => [x, x])"
    consume = "(x => null)"
    fst' = "(([x, _]) => x)"
    snd' = "(([_, y]) => y)"

instance Cocartesian JSLamb where
    injectL = "(x => ({tag: 'left', value: x}))"
    injectR = "(x => ({tag: 'right', value: x}))"
    unify = "(x => x.value)"
    tag = "(([b, x]) => ({tag: b ? 'right' : 'left', value: x}))"

instance Strong JSLamb where
    first' (JSLamb f) = JSLamb $ "(([x, y]) => [" <> f <> "(x), y])"
    second' (JSLamb f) = JSLamb $ "(([x, y]) => [x, " <> f <> "(y)])"

instance Choice JSLamb where
    left' (JSLamb f) = JSLamb $ "(({tag, value}) => ({tag, value: tag === 'left' ? " <> f <> " (value) : value}))"
    right' (JSLamb f) = JSLamb $ "(({tag, value}) => ({tag, value: tag === 'right' ? " <> f <> " (value) : value}))"

instance Symmetric JSLamb where
    swap = "(([a, b]) => [b, a]))"
    swapEither = "(({tag, value}) => ({tag: tag === \"left\" ? \"right\" : \"left\", value}))"
    reassoc = "(([a, [b, c]]) => [[a, b], c])"
    reassocEither = "reassoc either stuff"

-- instance Symmetric JSLamb where

-- instance Cochoice JSLamb where

-- instance Costrong JSLamb where

-- instance Apply JSLamb where

instance Primitive JSLamb where
    eq = "(([x, y]) => x === y)"
    reverseString = "(x => x.split('').reverse().join(''))"

instance PrimitiveConsole JSLamb where
    outputString = "console.log"
    inputString = "prompt"

instance Numeric JSLamb where
    num n = JSLamb $ "(_ => " <> show n <> ")"
    negate' = "(x => -x)"
    add = "(([x, y]) => x + y)"
    mult = "(([x, y]) => x * y)"
    div' = "(([x, y]) => x / y)"
    mod' = "(([x, y]) => x % y)"

instance Render (JSLamb a b) where
    render (JSLamb f) = f

-- @TODO escape shell - Text.ShellEscape?
instance ExecuteJSON JSLamb where
    executeViaJSON cat param = decode . BSL.pack . secondOfThree <$> liftIO (readProcessWithExitCode "node" ["-e", "console.log(JSON.stringify(" <> render cat <> "(" <> BSL.unpack (encode param) <> ")))"] "")

instance ExecuteStdio JSLamb where
    executeViaStdio cat stdin = secondOfThree <$> liftIO (readProcessWithExitCode "node" ["-e", render cat <> "()"] stdin)
