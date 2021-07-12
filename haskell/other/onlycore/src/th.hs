{-# LANGUAGE TemplateHaskell #-}

import           Lib.TH

main :: IO ()
main = do
    putStrLn $(self)
    putStrLn $$(selfTyped)