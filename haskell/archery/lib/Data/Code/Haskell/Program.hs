{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Safe              #-}

module Data.Code.Haskell.Program where

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
-- import Control.Category.Primitive.Extra
import Control.Category.Strong
import Control.Category.Symmetric
import Control.Exception hiding (bracket)
import Control.Monad.IO.Class
import Data.ByteString.Lazy.Char8          qualified as BSL
import Data.Render
import Data.Set
import Data.String
import GHC.IO.Exception
import Prelude                             hiding (id, (.))
import System.Process
import Text.Read

type Import = BSL.ByteString

data HSProg a b = HSProg (Set Import) BSL.ByteString
    deriving (Eq, Show)

instance IsString (HSProg a b) where
    fromString = HSProg [] . BSL.pack

instance Render (HSProg a b) where
    render (HSProg _ f) = f -- @TODO is

instance Bracket HSProg where
    bracket s = HSProg [] $ "(" <> render s <> ")"

instance Category HSProg where
    id = "id"
    a . b = HSProg [] $ "(" <> render a <> " . " <> render b <> ")"

instance Cartesian HSProg where
    copy = HSProg ["Control.Category.Cartesian"] "copy"
    consume = HSProg ["Control.Category.Cartesian"] "consume"
    fst' = "fst"
    snd' = "snd"

instance Cocartesian HSProg where
    injectL = "Left"
    injectR = "Right"
    unify = HSProg ["Control.Category.Cocartesian"] "unify"
    tag = HSProg ["Control.Category.Cartesian"] "tag"

instance Strong HSProg where
    -- @TODO apply? Bracket?
    first' f = HSProg ["Data.Bifunctor"] $ "(first " <> render f <> ")"
    second' f = HSProg ["Data.Bifunctor"] $ "(second " <> render f <> ")"

instance Choice HSProg where
    left' f = HSProg [] $ "(\\case { Left a -> Left (" <> render f <> " a); Right a -> Right a; })"
    right' f = HSProg [] $ "(\\case { Left a -> Left a; Right a -> Right (" <> render f <> " a); })"

instance Symmetric HSProg where
    swap = "(\\(a, b) -> (b, a))"
    swapEither = "(\\case { Left a -> Right a; Right a -> Left a; })"
    reassoc = "(\\(a, (b, c)) -> ((a, b), c))"
    reassocEither = "(\\case { Left a -> Left (Left a); Right (Left b) -> Left (Right b); Right (Right c) -> Right c })"

-- instance Cochoice HSProg where

-- instance Costrong HSProg where

-- instance Apply HSProg where

instance Primitive HSProg where
    eq = "(arr . uncurry $ (==))"
    reverseString = "(arr reverse)"

instance PrimitiveConsole HSProg where
    outputString = "(Kleisli putStr)"
    inputString = "(Kleisli (const getContents))"

instance Numeric HSProg where
    num n = HSProg [] $ "(const " <> fromString (show n) <> ")"
    negate' = "negate"
    add = "(uncurry (+))"
    mult = "(uncurry (*))"
    div' = "(uncurry div)"
    mod' = "(uncurry mod)"

-- @TODO escape shell - Text.ShellEscape?
instance ExecuteHaskell HSProg where
    executeViaGHCi cat param = do
        (exitCode, stdout, stderr) <- liftIO (readProcessWithExitCode "ghci" ["-e", ":set -XLambdaCase", "-e", "import Control.Arrow", "-e", "import Prelude hiding ((.), id)", "-e", "import Control.Category", "-e", BSL.unpack (render cat) <> " " <> show param] "")
        case exitCode of
            ExitFailure code -> liftIO . throwIO . userError $ "Exit code " <> show code <> ": " <> stderr 
            ExitSuccess -> case readEither stdout of
                Left err -> liftIO . throwIO . userError $ "Can't parse response: " <> err
                Right ret -> pure ret

-- @TODO this passes too many arguments apparently...
-- This is because of the id and (.) using the (->) instance whereas I am running Kleisli below.
-- This means we need to deal with both within Haskell sessions. Let's try to use Pure/Monadic... or maybe HSPure / HSMonadic accepting only appropriate typeclasses / primitives?
instance ExecuteStdio HSProg where
    executeViaStdio cat stdin = do
        (exitCode, stdout, stderr) <- liftIO (readProcessWithExitCode "ghci" ["-e", ":set -XLambdaCase", "-e", "import Control.Arrow", "-e", "import Prelude hiding ((.), id)", "-e", "import Control.Category", "-e", BSL.unpack (render cat) <> " ()"] (show stdin))
        case exitCode of
            ExitFailure code -> liftIO . throwIO . userError $ "Exit code " <> show code <> ": " <> stderr 
            ExitSuccess -> case readEither stdout of
                Left err -> liftIO . throwIO . userError $ "Can't parse response: " <> err
                Right ret -> pure ret

-- @ TODO JSON
