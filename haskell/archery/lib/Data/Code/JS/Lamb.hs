{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Unsafe            #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Data.Code.JS.Lamb where

import Control.Category
-- import Control.Category.Apply
import Control.Category.Bracket
import Control.Category.Cartesian
import Control.Category.Choice
import Control.Category.Cocartesian
import Control.Category.Execute.JSON
import Control.Category.Execute.Stdio
import Control.Category.Numeric
import Control.Category.Primitive.Abstract
import Control.Category.Primitive.Console
import Control.Category.Primitive.Extra
import Control.Category.Strong
import Control.Category.Symmetric
import Control.Monad.IO.Class
import Control.Exception hiding (bracket)
import Data.Aeson
import Data.ByteString.Lazy.Char8          qualified as BSL
import Data.Render
import Data.String
import GHC.IO.Exception
import Prelude                             hiding (id, (.))
import System.Process
import Text.Read

newtype JSLamb a b = JSLamb BSL.ByteString
    deriving (Eq, Show)

instance IsString (JSLamb a b) where
    fromString = JSLamb . BSL.pack

instance Render (JSLamb a b) where
    render (JSLamb f) = f

instance Bracket JSLamb where
    bracket s = JSLamb $ "(" <> render s <> ")"

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
    reassocEither = error "Not yet implemented"

-- instance Cochoice JSLamb where

-- instance Costrong JSLamb where

-- instance Apply JSLamb where

instance Primitive JSLamb where
    eq = "(([x, y]) => x === y)"
    reverseString = "(x => x.split('').reverse().join(''))"

instance PrimitiveConsole JSLamb where
    outputString = "console.log"
    inputString = "prompt"

instance PrimitiveExtra JSLamb where
    intToString = "(i => i.toString())"
    concatString = "([a, b]) => a + b"
    constString s = JSLamb $ "(() => \"" <> BSL.pack s <> "\")"

instance Numeric JSLamb where
    num n = JSLamb $ "(_ => " <> BSL.pack (show n) <> ")"
    negate' = "(x => -x)"
    add = "(([x, y]) => x + y)"
    mult = "(([x, y]) => x * y)"
    div' = "(([x, y]) => x / y)"
    mod' = "(([x, y]) => x % y)"

-- @TODO escape shell - Text.ShellEscape?
instance ExecuteJSON JSLamb where
    executeViaJSON cat param = do
        (exitCode, stdout, stderr) <- liftIO (readProcessWithExitCode "node" ["-e", "console.log(JSON.stringify(" <> BSL.unpack (render cat) <> "(" <> BSL.unpack (encode param) <> ")))"] "")
        case exitCode of
            ExitFailure code -> liftIO . throwIO . userError $ "Exit code " <> show code <> ": " <> stderr 
            ExitSuccess -> case eitherDecode (BSL.pack stdout) of
                Left err -> liftIO . throwIO . userError $ "Can't parse response: " <> err
                Right ret -> pure ret

instance ExecuteStdio JSLamb where
    executeViaStdio cat stdin = do
        (exitCode, stdout, stderr) <- liftIO (readProcessWithExitCode "node" ["-e", BSL.unpack (render cat) <> "()"] (show stdin))
        case exitCode of
            ExitFailure code -> liftIO . throwIO . userError $ "Exit code " <> show code <> ": " <> stderr 
            ExitSuccess -> case readEither stdout of
                Left err -> liftIO . throwIO . userError $ "Can't parse response: " <> err
                Right ret -> pure ret