{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

import Data.Conduit.Shell

main ∷ IO ()
main = run $ do
    ls ["-lah"]
