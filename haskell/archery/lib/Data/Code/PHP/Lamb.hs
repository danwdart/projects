{-# LANGUAGE OverloadedStrings, Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Data.Code.PHP.Lamb where

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

data PHPLamb a b = PHPLamb String
    deriving (Eq, Show)

instance IsString (PHPLamb a b) where
    fromString = PHPLamb

instance Category PHPLamb where
    id = "($x => $x)"
    PHPLamb a . PHPLamb b = PHPLamb $ "(fn ($x) => " <> a <> "(" <> b <> "($x)))"

instance Cartesian PHPLamb where
    copy = "(fn ($x) => [$x, $x])"
    consume = "(fn ($x) => null)"
    fst' = "(fn ($x) => $x[0])"
    snd' = "(fn ($x) => $x[1])"

instance Cocartesian PHPLamb where
    injectL = "(fn ($x) => ['tag' => 'left', 'value' => $x])"
    injectR = "(fn ($x) => ['tag' => 'right', 'value' => $x])"
    unify = "(fn ($x) => $x['value'])"
    tag = "(fn ($x) => ['tag' => $x[0] ? 'right' : 'left', 'value' => $x[1]])"

instance Strong PHPLamb where
    first' (PHPLamb f) = PHPLamb $ "(fn ($x) => [" <> f <> "($x[0]), $x[1]])"
    second' (PHPLamb f) = PHPLamb $ "(fn ($x) => [$x[0], " <> f <> "($x[1])])"

instance Choice PHPLamb where
    left' (PHPLamb f) = PHPLamb $ "(fn ($x) => ['tag' => $x['tag'], 'value' => $x['tag'] === 'left' ? " <> f <> " ($x['value']) : $x['value']])"
    right' (PHPLamb f) = PHPLamb $ "(fn ($x) => ['tag' => $x['tag'], 'value' => $x['tag'] === 'right' ? " <> f <> " ($x['value']) : $x['value']])"

instance Symmetric PHPLamb where
    swap = "(fn ($a) => [$a[1], $a[0]]))"
    swapEither = "(fn ($a) => (['tag' => $a['tag'] === \"left\" ? \"right\" : \"left\", 'value' => $a['value']]))"
    reassoc = "(([a, [b, c]]) => [[a, b], c])"
    reassocEither = "Unacceptable, test failure!"

-- instance Cochoice PHPLamb where

-- instance Costrong PHPLamb where

-- instance Apply PHPLamb where

instance Primitive PHPLamb where
    eq = "(fn ($x) => $x[0] === $x[1])"
    reverseString = "(fn ($x) => strrev($x))"

instance PrimitiveConsole PHPLamb where
    outputString = "print"
    inputString = "(function () { $r = fopen('php://stdin', 'r'); $ret = fgets($r); fclose($r); return $ret; })" -- difficult to not miss nullary functions

instance Numeric PHPLamb where
    num n = PHPLamb $ "(fn () => " <> show n <> ")"
    negate' = "(fn ($x) => -$x)"
    add = "(fn ($x) => $x[0] + $x[1])"
    mult = "(fn ($x) => $x[0] * $x[1])"
    div' = "(fn ($x) => $x[0] / $x[1])"
    mod' = "(fn ($x) => $x[0] % $x[1])"

instance Render (PHPLamb a b) where
    render (PHPLamb f) = f

-- @TODO escape shell - Text.ShellEscape?
instance ExecuteJSON PHPLamb where
    executeViaJSON cat param = eitherDecode . BSL.pack . secondOfThree <$> liftIO (readProcessWithExitCode "php" ["-r", "print(json_encode(" <> render cat <> "(" <> BSL.unpack (encode param) <> ")));"] "")

instance ExecuteStdio PHPLamb where
    -- @TODO figure out why we have to have something here for argument - for now using null...
    executeViaStdio cat stdin = secondOfThree <$> liftIO (readProcessWithExitCode "php" ["-r", "(" <> render cat <> ")(null);"] stdin)
