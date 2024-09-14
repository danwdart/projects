{-# LANGUAGE CPP              #-}
{-# LANGUAGE JavaScriptFFI    #-}
{-# LANGUAGE MonoLocalBinds   #-}
{-# LANGUAGE TemplateHaskell  #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE Unsafe           #-}
{-# OPTIONS_GHC -Wno-type-defaults -Wno-unused-matches -Wno-unused-local-binds #-}

module Main (main) where

import Control.Exception
import Env
import Language.Haskell.TH
import System.Environment

main ∷ IO ()
main = do
    let envCompileTime ∷ String
        envCompileTime = $(stringE =<< runIO (catch (getEnv "ENV") (\(SomeException ex) -> pure $ "Env Compile Time Unset: " <> show ex)))
        readFileCompileTime ∷ String
        readFileCompileTime = $(stringE =<< runIO (catch (readFile "/etc/passwd") (\(SomeException ex) -> pure $ "readFile Compile Time Unset: " <> show ex)))
        envFFICompileTime :: String
        envFFICompileTime = $(stringE =<< runIO (catch (envVar "ENV") (\(SomeException ex) -> pure $ "readFile Compile Time Unset: " <> show ex)))
    envRuntime <- catch (getEnv "ENV") (\(SomeException ex) -> pure $ "Env Runtime / Unset: " <> show ex)
    readFileRuntime <- catch (readFile "/etc/passwd") (\(SomeException ex) -> pure $ "readFile Runtime Unset: " <> show ex)
    envFFIRuntime <- catch (envVar "ENV") (\(SomeException ex) -> pure $ "envFFI Compile Time Unset: " <> show ex)
    print [("env", [("envCompileTime", envCompileTime), ("envRuntime", envRuntime), ("envFFICompileTime", envFFICompileTime), ("envFFIRuntime", envFFIRuntime)]), ("readFile", [("readFileCompileTime", readFileCompileTime), ("readFileRuntime", readFileRuntime)])]
