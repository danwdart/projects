{-# LANGUAGE TemplateHaskell #-}

import           Lib.TH

-- something :: String
-- something = [s| s hello hi |]

main :: IO ()
main = do
    putStrLn $(self)
    putStrLn $$(selfTyped)