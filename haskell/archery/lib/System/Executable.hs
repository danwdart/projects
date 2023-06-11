{-# LANGUAGE Safe #-}

module System.Executable where

import Control.Exception
import Control.Monad.IO.Class
import Data.ByteString.Lazy.Char8 qualified as BSL
import Data.List
import GHC.IO.Exception
import System.Console.GetOpt
import System.Environment
import System.Process
import Text.Read

data CLIOptionsWithOutput = CLIOptionsWithOutput {
    input :: Maybe String,
    output :: Maybe String
} deriving (Eq, Show)

defaultOptionsWithOutput :: CLIOptionsWithOutput
defaultOptionsWithOutput = CLIOptionsWithOutput {
    input = Nothing,
    output = Nothing
}

newtype CLIOptionsWithoutOutput = CLIOptionsWithoutOutput {
    singleInput :: Maybe String
}

defaultOptionsWithoutOutput :: CLIOptionsWithoutOutput
defaultOptionsWithoutOutput = CLIOptionsWithoutOutput {
    singleInput = Nothing
}

-- 'TODO maybe we need an Alternative instance?
insertOptionsWithOutputFromList :: [String] -> CLIOptionsWithOutput -> CLIOptionsWithOutput
insertOptionsWithOutputFromList [a] cliOptions@(CLIOptionsWithOutput Nothing _) = cliOptions { input = Just a }
insertOptionsWithOutputFromList [a] cliOptions@(CLIOptionsWithOutput (Just _) Nothing) = cliOptions { output = Just a }
insertOptionsWithOutputFromList [a, b] cliOptions@(CLIOptionsWithOutput Nothing Nothing) = cliOptions { input = Just a, output = Just b}
insertOptionsWithOutputFromList _ cliOptions = cliOptions

-- 'TODO maybe we need an Alternative instance?
insertOptionsWithoutOutputFromList :: [String] -> CLIOptionsWithoutOutput -> CLIOptionsWithoutOutput
insertOptionsWithoutOutputFromList [a] cliOptions@(CLIOptionsWithoutOutput Nothing) = cliOptions { singleInput = Just a }
insertOptionsWithoutOutputFromList _ cliOptions = cliOptions

optionsProducingOutput :: [OptDescr (CLIOptionsWithOutput -> CLIOptionsWithOutput)]
optionsProducingOutput = [
        Option ['i'] ["input"] (ReqArg (\f cliOptions -> cliOptions { input = Just f } ) "FILE") "file to process",
        Option ['o'] ["output"] (ReqArg (\f cliOptions -> cliOptions { output = Just f } ) "FILE") "file to produce"
    ]

optionsNotProducingOutput :: [OptDescr (CLIOptionsWithoutOutput -> CLIOptionsWithoutOutput)]
optionsNotProducingOutput = [
        Option ['i'] ["input"] (ReqArg (\f cliOptions -> cliOptions { singleInput = Just f } ) "FILE") "file to process"
    ]

parseAllProducingOutput :: IO CLIOptionsWithOutput
parseAllProducingOutput = do
    argv <- getArgs
    case getOpt Permute optionsProducingOutput argv of
        (o, n, []) -> do
            let parsed = foldl (flip id) defaultOptionsWithOutput o
                includingUnparsed = insertOptionsWithOutputFromList n parsed
            pure includingUnparsed
        (_, _, errs) -> do
            progName <- getProgName
            ioError (userError (concat errs ++ usageInfo (header progName) optionsProducingOutput))
    where header progName = "Usage: " <> progName <> " [OPTION...] files..."

parseAllNotProducingOutput :: IO CLIOptionsWithoutOutput
parseAllNotProducingOutput = do
    argv <- getArgs
    case getOpt Permute optionsNotProducingOutput argv of
        (o, n, []) -> do
            let parsed = foldl (flip id) defaultOptionsWithoutOutput o
                includingUnparsed = insertOptionsWithoutOutputFromList n parsed
            pure includingUnparsed
        (_, _, errs) -> do
            progName <- getProgName
            ioError (userError (concat errs ++ usageInfo (header progName) optionsNotProducingOutput))
    where header progName = "Usage: " <> progName <> " [OPTION...] files..."

getFileOrContents :: Maybe String -> IO BSL.ByteString
getFileOrContents = maybe BSL.getContents BSL.readFile

writeFileOrStdout :: Maybe String -> BSL.ByteString -> IO ()
writeFileOrStdout = maybe BSL.putStr BSL.writeFile

readToWrite :: (BSL.ByteString -> IO BSL.ByteString) -> IO ()
readToWrite transformer = do
    parsed <- parseAllProducingOutput

    getFileOrContents (input parsed) >>= transformer >>= writeFileOrStdout (output parsed)

readToOp :: (BSL.ByteString -> IO a) -> IO a
readToOp transformer = do
    parsed <- parseAllNotProducingOutput

    getFileOrContents (singleInput parsed) >>= transformer

compileHS :: BSL.ByteString -> IO ()
compileHS fileContents = do
    let params :: [String]
        params = ["-e", ":set -XLambdaCase", "-e", "import Control.Arrow", "-e", "import Prelude hiding ((.), id)", "-e", "import Control.Category", "-e", "runKleisli (" <> BSL.unpack fileContents <> ") ()"]
    (exitCode, stdout, stderr) <- liftIO (readProcessWithExitCode "ghc" params "")
    case exitCode of
        ExitFailure code -> liftIO . throwIO . userError $ "Exit code " <> show code <> " when attempting to run ghci with params: " <> concat (intersperse " " params) <> " Output: " <> stderr 
        ExitSuccess -> case readEither stdout of
            Left err -> liftIO . throwIO . userError $ "Can't parse response: " <> err
            Right ret -> pure ret
