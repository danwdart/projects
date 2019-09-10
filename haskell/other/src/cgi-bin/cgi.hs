#!/usr/bin/env runhaskell
main :: IO ()
main = putStrLn "200 OK\nX-Server: Dans-Haskell\nContent-Type: text/html\n\n<!doctype html><html><h1>Hello World!</h1></html>"