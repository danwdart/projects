{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

import           Network.HTTP.Types       (status200)
import           Network.Wai
import           Network.Wai.Handler.Warp (run)

application ∷ p → (Response → t) → t
application _ respond = respond $
  responseLBS status200 [("Content-Type", "text/plain")] "Hello World"

main ∷ IO ()
main = run 3000 application
