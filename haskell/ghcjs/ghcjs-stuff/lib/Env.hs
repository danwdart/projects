{-# LANGUAGE CPP              #-}
{-# LANGUAGE Unsafe           #-}

#if defined(__GHCJS__)

{-# LANGUAGE JavaScriptFFI    #-}

module Env (envVar) where

import Control.Exception
import GHCJS.DOM.Types

foreign import javascript unsafe "this.process !== undefined ? process.env[$1] : \"No process!\"" js_envVar :: JSString → IO JSString

envVar :: String -> IO String
envVar k = catch (do
    let p = toJSString k
    v <- js_envVar p
    pure $ fromJSString v) (\(SomeException ex) -> pure $ "Exception caught in js_envVar: " <> show ex)
#else
module Env (envVar) where

import System.Environment

envVar :: String -> IO String
envVar = getEnv
#endif
