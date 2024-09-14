{-# LANGUAGE JavaScriptFFI #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module MyLib (someFunc) where

import Control.Exception
import GHC.JS.Prim
-- import GHC.JS.Foreign.Callback
import System.Environment
import Language.Haskell.TH

someFunc ∷ IO ()
someFunc = do
    creaGloVar (toJSString "hello") (toJSString "world")
    let compileTimeEnv :: String
        compileTimeEnv = $(stringE . show =<< runIO (try @SomeException $ getEnv "ENV"))
    runtimeEnv <- show <$> (try @SomeException $ getEnv "ENV")
    print @[(String, String)] [("compileTimeEnv", compileTimeEnv), ("runtimeEnv", runtimeEnv)]
    inject

-- static struct??? why??? we don't do this yet
-- foreign export javascript "h$someFunc" someFunc :: IO ()

foreign import javascript unsafe "inject" inject :: IO ()

foreign import javascript unsafe "((x, y) => { this[x] = y })"
  creaGloVar :: JSVal -> JSVal -> IO ()