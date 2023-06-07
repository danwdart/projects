{-# LANGUAGE OverloadedStrings, Safe #-}

module Data.Code.Haskell.Lamb where

import Control.Category
import Control.Category.Cartesian
import Control.Category.Choice
import Control.Category.Cocartesian
import Control.Category.Execute.Haskell
import Control.Category.Execute.Stdio
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

data HSLamb a b = HSLamb String
    deriving (Eq, Show)

-- instance Profunctor HSLamb where
--     dimap :: (a -> b) -> (c -> d) -> HSLamb b c -> HSLamb a d
--     dimap contra cova (HSLamb f) = HSLamb $ "(\\x -> )"

instance IsString (HSLamb a b) where
    fromString = HSLamb

instance Category HSLamb where
    id = "(\\x -> x)"
    -- Ohh, this is the Function instance for (.)... @TODO fix this to use the Category instance if we want both Kleisli and (->) to work!
    -- TBH we should probably fix up Kleisli by using a Monadic or Pure typeclass to specify.
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
    outputString = "(Kleisli putStr)"
    inputString = "(Kleisli (const getContents))"

instance Numeric HSLamb where
    num n = HSLamb $ "(\\_ -> " <> show n <> ")"
    negate' = "negate"
    add = "(\\(x, y) -> x + y)"
    mult = "(\\(x, y) -> x * y)"
    div' = "(\\(x, y) -> div x y)"
    mod' = "(\\(x, y) -> mod x y)"

instance Render (HSLamb a b) where
    render (HSLamb f) = f

-- @TODO escape shell - Text.ShellEscape?
instance ExecuteHaskell HSLamb where
    executeViaGHCi cat param = read . secondOfThree <$> liftIO (readProcessWithExitCode "ghci" ["-e", ":set -XLambdaCase", "-e", "import Control.Arrow", "-e", render cat <> " " <> show param] "")

-- @TODO this passes too many arguments apparently...
-- This is because of the id and (.) using the (->) instance whereas I am running Kleisli below.
-- This means we need to deal with both within Haskell sessions. Let's try to use Pure/Monadic... or maybe HSPure / HSMonadic accepting only appropriate typeclasses / primitives?
instance ExecuteStdio HSLamb where
    executeViaStdio cat stdin = secondOfThree <$> liftIO (readProcessWithExitCode "ghci" ["-e", ":set -XLambdaCase", "-e", "import Control.Arrow", "-e", "import Prelude hiding ((.), id)", "-e", "import Control.Category", "-e", "runKleisli " <> render cat <> " ()"] stdin)

-- @ TODO JSON