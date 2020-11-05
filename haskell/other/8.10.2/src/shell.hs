{-# LANGUAGE UnicodeSyntax #-}
import           Data.Conduit.Shell

main ∷ IO ()
main = run $ do
    ps ["-aux"]
    ls ["-lah"]
