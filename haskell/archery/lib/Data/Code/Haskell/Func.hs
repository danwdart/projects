{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Safe              #-}

module Data.Code.Haskell.Func where

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
import Control.Exception hiding (bracket)
import Control.Monad.IO.Class
import Data.ByteString.Lazy.Char8          qualified as BSL
import Data.Render
import Data.String
import GHC.IO.Exception
import Prelude                             hiding (id, (.))
import System.Process
import Text.Read

newtype HSFunc a b = HSFunc BSL.ByteString
    deriving (Eq, Show)

instance IsString (HSFunc a b) where
    fromString = HSFunc . BSL.pack

instance Render (HSFunc a b) where
    render (HSFunc f) = f

instance Bracket HSFunc where
    bracket s = HSFunc $ "(" <> render s <> ")"

instance Category HSFunc where
    id = "id"
    a . b = bracket $ HSFunc (render a <> " . " <> render b)

instance Cartesian HSFunc where
    copy = bracket "\\x -> (x, x)"
    consume = bracket "const ()"
    fst' = "fst"
    snd' = "snd"

instance Cocartesian HSFunc where
    injectL = "Left"
    injectR = "Right"
    unify = bracket "\\case { Left a -> a; Right a -> a; }"
    tag = bracket "\\case { (False, a) -> Left a; (True, a) -> Right a; }"

instance Strong HSFunc where
    first' f = HSFunc $ "(Data.Bifunctor.first " <> render f <> ")"
    second' f = HSFunc $ "(Data.Bifunctor.second " <> render f <> ")"

instance Choice HSFunc where
    left' f = HSFunc $ "(\\case { Left a -> Left (" <> render f <> " a); Right a -> Right a; })"
    right' f = HSFunc $ "(\\case { Left a -> Left a; Right a -> Right (" <> render f <> " a); })"

instance Symmetric HSFunc where
    swap = "(\\(a, b) -> (b, a))"
    swapEither = "(\\case { Left a -> Right a; Right a -> Left a; })"
    reassoc = "(\\(a, (b, c)) -> ((a, b), c))"
    reassocEither = "(\\case { Left a -> Left (Left a); Right (Left b) -> Left (Right b); Right (Right c) -> Right c })"

-- instance Cochoice HSFunc where

-- instance Costrong HSFunc where

-- instance Apply HSFunc where

instance Primitive HSFunc where
    eq = "(arr . uncurry $ (==))"
    reverseString = "(arr reverse)"

instance PrimitiveConsole HSFunc where
    outputString = "(Kleisli putStr)"
    inputString = "(Kleisli (const getContents))"

instance PrimitiveExtra HSFunc where
    intToString = "show"
    concatString = "(uncurry (<>))"
    constString s = HSFunc $ "(const \"" <> BSL.pack s <> "\")"

instance Numeric HSFunc where
    num n = HSFunc $ "(const " <> fromString (show n) <> ")"
    negate' = "negate"
    add = "(uncurry (+))"
    mult = "(uncurry (*))"
    div' = "(uncurry div)"
    mod' = "(uncurry mod)"

-- @TODO escape shell - Text.ShellEscape?
instance ExecuteHaskell HSFunc where
    executeViaGHCi cat param = do
        (exitCode, stdout, stderr) <- liftIO (readProcessWithExitCode "ghci" ["-e", ":set -XLambdaCase", "-e", "import Control.Arrow", "-e", "import Prelude hiding ((.), id)", "-e", "import Control.Category", "-e", BSL.unpack (render cat) <> " " <> show param] "")
        case exitCode of
            ExitFailure code -> liftIO . throwIO . userError $ "Exit code " <> show code <> ": " <> stderr 
            ExitSuccess -> case readEither stdout of
                Left err -> liftIO . throwIO . userError $ "Can't parse response: " <> err
                Right ret -> pure ret
        
-- @TODO this uses runKleisli, the above does not

instance ExecuteStdio HSFunc where
    executeViaStdio cat stdin = do
        (exitCode, stdout, stderr) <- liftIO (readProcessWithExitCode "ghci" ["-e", ":set -XLambdaCase", "-e", "import Control.Arrow", "-e", "import Prelude hiding ((.), id)", "-e", "import Control.Category", "-e", "runKleisli (" <> BSL.unpack (render cat) <> ") ()"] (show stdin))
        case exitCode of
            ExitFailure code -> liftIO . throwIO . userError $ "Exit code " <> show code <> ": " <> stderr 
            ExitSuccess -> case readEither stdout of
                Left err -> liftIO . throwIO . userError $ "Can't parse response: " <> err
                Right ret -> pure ret

-- @ TODO JSON
