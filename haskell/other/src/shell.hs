import Data.Conduit.Shell

main :: IO ()
main = do
    run $ ps ["-aux"]
    run $ ls ["-lah"]