{-# LANGUAGE TemplateHaskell #-}

import Language.Haskell.TH

evilAlien :: Q String
evilAlien = runIO $ readFile "th.hs"

main :: IO ()
main = do
    let ea = $(evilAlien)
    print ea
