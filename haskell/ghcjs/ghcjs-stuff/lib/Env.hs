{-# LANGUAGE CPP              #-}
{-# LANGUAGE JavaScriptFFI    #-}
{-# LANGUAGE Unsafe           #-}

module Env (envVar) where

#if defined(__GHCJS__)
import GHCJS.DOM.Types

foreign import javascript unsafe "process.env[$1]" js_envVar :: JSString → IO JSString

envVar :: String -> IO String
envVar k = do
    let p = toJSString k
    v <- js_envVar p
    pure $ fromJSString v
#else
import System.Environment

envVar :: String -> IO String
envVar = getEnv
#endif
