{-# LANGUAGE CPP               #-}
{-# LANGUAGE JavaScriptFFI     #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Data.JSString

foreign import javascript "data" datas :: JSString
foreign import javascript "io()" io :: IO ()
foreign import javascript "fn($1)" fn :: JSString -> JSString
foreign import javascript "add($1)" add :: Int -> Int

run :: JSString -> IO () -> (JSString -> JSString) -> (Int -> Int) -> IO ()
run datas' io' fn' add' = do
    let dataS = unpack datas'
    putStrLn dataS

    io'

    let wrappedFn = unpack . fn' . pack
    let ah = wrappedFn "Hi!"
    putStrLn $ "Answer: " <> ah

    let k = add' 2
    print k

main :: IO ()
main = run datas io fn add
