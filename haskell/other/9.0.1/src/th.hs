{-# LANGUAGE TemplateHaskell #-}

import Language.Haskell.TH

evilAlien :: String
evilAlien = [d|
    readFile "th.hs"
    |]

main :: IO ()
main = pure ()