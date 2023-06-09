{-# LANGUAGE OverloadedStrings, Safe #-}

module Data.Code.Haskell.Lamb where

import Control.Category
-- import Control.Category.Apply
import Control.Category.Bracket
import Control.Category.Cartesian
import Control.Category.Choice
import Control.Category.Cocartesian
import Control.Category.Execute.Haskell
import Control.Category.Execute.Stdio
import Control.Category.Numeric
import Control.Category.Primitive.Abstract
import Control.Category.Primitive.Console
import Control.Category.Primitive.Extra
import Control.Category.Strong
import Control.Category.Symmetric
import Control.Monad.IO.Class
import Data.ByteString.Lazy.Char8 qualified as BSL
import Data.Render
import Data.String
import Data.Tuple.Triple
import Prelude hiding ((.), id)
import System.Process
import Text.Read

newtype HSLamb a b = HSLamb BSL.ByteString
    deriving (Eq, Show)

-- instance Profunctor HSLamb where
--     dimap :: (a -> b) -> (c -> d) -> HSLamb b c -> HSLamb a d
--     dimap contra cova (HSLamb f) = HSLamb $ "(\\x -> )"

instance IsString (HSLamb a b) where
    fromString = HSLamb . BSL.pack

instance Render (HSLamb a b) where
    render (HSLamb f) = f

instance Bracket HSLamb where
    bracket s = HSLamb $ "(" <> render s <> ")"

instance Category HSLamb where
    id = bracket "\\x -> x"
    -- Ohh, this is the Function instance for (.)... @TODO fix this to use the Category instance if we want both Kleisli and (->) to work!
    -- TBH we should probably fix up Kleisli by using a Monadic or Pure typeclass to specify.
    a . b = bracket . HSLamb $ "\\x -> " <> render a <> " ( " <> render b <> " x)" -- f . g = f (g x), not g (f x)

instance Cartesian HSLamb where
    copy = bracket "\\x -> (x, x)"
    consume = bracket "\\x -> ()"
    fst' = bracket "\\(x, _) -> x"
    snd' = bracket "\\(_, y) -> y"

instance Cocartesian HSLamb where
    injectL = "Left"
    injectR = "Right"
    unify = bracket "\\case { Left a -> a; Right a -> a; }"
    tag = bracket "\\case { (False, a) -> Left a; (True, a) -> Right a; }"

instance Strong HSLamb where
    first' f = bracket . HSLamb $ "\\(x, y) -> (" <> render f <> " x, y)"
    second' f = bracket . HSLamb $ "\\(x, y) -> (x, " <> render f <> " y)"

instance Choice HSLamb where
    left' f = bracket . HSLamb $ "\\case { Left a -> Left (" <> render f <> " a); Right a -> Right a; }"
    right' f = bracket . HSLamb $ "\\case { Left a -> Left a; Right a -> Right (" <> render f <> " a); }"

instance Symmetric HSLamb where
    swap = bracket "\\(a, b) -> (b, a)"
    swapEither = bracket "\\case { Left a -> Right a; Right a -> Left a; }"
    reassoc = bracket "\\(a, (b, c)) -> ((a, b), c)"
    reassocEither = bracket "\\case { Left a -> Left (Left a); Right (Left b) -> Left (Right b); Right (Right c) -> Right c }"

-- instance Cochoice HSLamb where

-- instance Costrong HSLamb where

-- instance Apply HSLamb where

instance Primitive HSLamb where
    eq = bracket "arr (\\(x, y) -> x == y)"
    reverseString = bracket "arr reverse"

instance PrimitiveConsole HSLamb where
    outputString = bracket "Kleisli putStr"
    inputString = bracket "Kleisli (const getContents)"

instance PrimitiveExtra HSLamb where
    intToString = "show"
    concatString = "(uncurry (<>))"
    constString s = HSLamb $ "(const \"" <> BSL.pack s <> "\")"

instance Numeric HSLamb where
    num n = bracket . HSLamb $ "\\_ -> " <> BSL.pack (show n)
    negate' = "negate"
    add = bracket "\\(x, y) -> x + y"
    mult = bracket "\\(x, y) -> x * y"
    div' = bracket "\\(x, y) -> div x y"
    mod' = bracket "\\(x, y) -> mod x y"

-- @TODO escape shell - Text.ShellEscape?
instance ExecuteHaskell HSLamb where
    executeViaGHCi cat param = readEither . secondOfThree <$> liftIO (readProcessWithExitCode "ghci" ["-e", ":set -XLambdaCase", "-e", "import Control.Arrow", "-e", BSL.unpack (render cat) <> " " <> show param] "")

-- @TODO this passes too many arguments apparently...
-- This is because of the id and (.) using the (->) instance whereas I am running Kleisli below.
-- This means we need to deal with both within Haskell sessions. Let's try to use Pure/Monadic... or maybe HSPure / HSMonadic accepting only appropriate typeclasses / primitives?
instance ExecuteStdio HSLamb where
    executeViaStdio cat stdin = read . secondOfThree <$> liftIO (readProcessWithExitCode "ghci" ["-e", ":set -XLambdaCase", "-e", "import Control.Arrow", "-e", "import Prelude hiding ((.), id)", "-e", "import Control.Category", "-e", "runKleisli " <> BSL.unpack (render cat) <> " ()"] (show stdin))

-- @ TODO JSON