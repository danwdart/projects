{-# LANGUAGE OverloadedStrings, Safe #-}

module Data.Code.Haskell.Lamb where

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

data HSLamb a b = HSLamb String
    deriving (Eq, Show)

-- instance Profunctor HSLamb where
--     dimap :: (a -> b) -> (c -> d) -> HSLamb b c -> HSLamb a d
--     dimap contra cova (HSLamb f) = HSLamb $ "(\\x -> )"

instance IsString (HSLamb a b) where
    fromString = HSLamb

instance Category HSLamb where
    id = "(\\x -> x)"
    HSLamb a . HSLamb b = HSLamb $ "(\\x -> " <> a <> " ( " <> b <> " x))" -- f . g = f (g x), not g (f x)

instance Cartesian HSLamb where
    copy = "(\\x -> (x, x))"
    consume = "(\\x -> ())"
    fst' = "(\\(x, _) -> x)"
    snd' = "(\\(_, y) -> y)"

instance Cocartesian HSLamb where
    injectL = "Left"
    injectR = "Right"
    unify = "(\\case { Left a -> a; Right a -> a; })"
    tag = "(\\case { (False, a) -> Left a; (True, a) -> Right a; })"

instance Strong HSLamb where
    first' (HSLamb f) = HSLamb $ "(\\(x, y) -> (" <> f <> " x, y))"
    second' (HSLamb f) = HSLamb $ "(\\(x, y) -> (x, " <> f <> " y))"

instance Choice HSLamb where
    left' (HSLamb f) = HSLamb $ "(\\case { Left a -> Left (" <> f <> " a); Right a -> Right a; })"
    right' (HSLamb f) = HSLamb $ "(\\case { Left a -> Left a; Right a -> Right (" <> f <> " a); })"

-- instance Symmetric HSLamb where

-- instance Cochoice HSLamb where

-- instance Costrong HSLamb where

-- instance Apply HSLamb where

instance Primitive HSLamb where
    eq = "(arr (\\(x, y) -> x == y))"
    reverseString = "(arr reverse)"

instance PrimitiveConsole HSLamb where
    outputString = "(Kleisli putStrLn)"
    inputString = "_TODO"

instance Numeric HSLamb where
    num n = HSLamb $ "(\\_ -> " <> show n <> ")"
    negate' = "negate"
    add = "(\\(x, y) -> x + y)"
    mult = "(\\(x, y) -> x * y)"
    div' = "(\\(x, y) -> div x y)"
    mod' = "(\\(x, y) -> mod x y)"


instance Render (HSLamb a b) where
    render (HSLamb f) = f

runInGHCiParamL :: (Show input, Read output) => HSLamb input output -> input -> IO output
runInGHCiParamL cat param = read . secondOfThree <$> readProcessWithExitCode "ghci" ["-e", ":set -XLambdaCase", "-e", "import Control.Arrow", "-e", render cat <> " " <> show param] ""
