{-# LANGUAGE JavaScriptFFI #-}
{-# LANGUAGE OverloadedStrings #-}

module MyLib (someFunc) where

import GHC.JS.Prim
-- import GHC.JS.Foreign.Callback

someFunc ∷ IO ()
someFunc = do
    creaGloVar (toJSString "hello") (toJSString "world")
    inject

-- static struct??? why??? we don't do this yet
-- foreign export javascript "h$someFunc" someFunc :: IO ()

foreign import javascript "inject" inject :: IO ()

foreign import javascript "((x, y) => { this[x] = y })"
  creaGloVar :: JSVal -> JSVal -> IO ()