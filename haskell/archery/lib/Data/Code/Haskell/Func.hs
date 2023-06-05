{-# LANGUAGE OverloadedStrings, Safe #-}

module Data.Code.Haskell.Func where

import Control.Category
import Control.Category.Cartesian
import Control.Category.Choice
import Control.Category.Cocartesian
import Control.Category.Execute.Haskell
import Control.Category.Numeric
import Control.Category.Primitive.Abstract
import Control.Category.Primitive.Console
import Control.Category.Strong
import Control.Monad.IO.Class
import Data.Render
import Data.String
import Data.Tuple.Triple
import Prelude hiding ((.), id)
import System.Process


data HSFunc a b = HSFunc String
    deriving (Eq, Show)

instance IsString (HSFunc a b) where
    fromString = HSFunc

instance Category HSFunc where
    id = "id"
    HSFunc a . HSFunc b = HSFunc $ "(" <> a <> " . " <> b <> ")"

instance Cartesian HSFunc where
    copy = "(\\x -> (x, x))"
    consume = "(const ())"
    fst' = "fst"
    snd' = "snd"

instance Cocartesian HSFunc where
    injectL = "Left"
    injectR = "Right"
    unify = "(\\case { Left a -> a; Right a -> a; })"
    tag = "(\\case { (False, a) -> Left a; (True, a) -> Right a; })"

instance Strong HSFunc where
    first' (HSFunc f) = HSFunc $ "(Data.Bifunctor.first " <> f <> ")"
    second' (HSFunc f) = HSFunc $ "(Data.Bifunctor.second " <> f <> ")"

instance Choice HSFunc where
    left' (HSFunc f) = HSFunc $ "(\\case { Left a -> Left (" <> f <> " a); Right a -> Right a; })"
    right' (HSFunc f) = HSFunc $ "(\\case { Left a -> Left a; Right a -> Right (" <> f <> " a); })"

-- instance Symmetric HSFunc where

-- instance Cochoice HSFunc where

-- instance Costrong HSFunc where

-- instance Apply HSFunc where

instance Primitive HSFunc where
    eq = "(arr . uncurry $ (==))"
    reverseString = "(arr reverse)"

instance PrimitiveConsole HSFunc where
    outputString = "(Kleisli putStrLn)"
    inputString = "(Kleisli (const getLine))"

instance Numeric HSFunc where
    num n = HSFunc $ "(const " <> show n <> ")"
    negate' = "negate"
    add = "(uncurry (+))"
    mult = "(uncurry (*))"
    div' = "(uncurry div)"
    mod' = "(uncurry mod)"

instance Render (HSFunc a b) where
    render (HSFunc f) = f

-- @TODO escape shell - Text.ShellEscape?
instance ExecuteHaskell HSFunc where
    executeViaGHCi cat param = read . secondOfThree <$> liftIO (readProcessWithExitCode "ghci" ["-e", ":set -XLambdaCase", "-e", "import Control.Arrow", "-e", render cat <> " " <> show param] "")

-- @ TODO JSON
