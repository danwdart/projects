{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE Trustworthy     #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

import TH

-- something :: String
-- something = [s| s hello hi |]

main ∷ IO ()
main = do
    putStrLn $(self)
    putStrLn $$(selfTyped)
