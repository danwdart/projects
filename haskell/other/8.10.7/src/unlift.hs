{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE UnicodeSyntax     #-}

import           Control.Monad.IO.Unlift
import           Relude

main ∷ MonadIO m ⇒ m ()
main = putStrLn "Hi"
