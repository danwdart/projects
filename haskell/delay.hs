import Control.Concurrent

typeSlow :: String -> IO ()
typeSlow = mapM_ (\c -> threadDelay 100000 >> putChar c)

main :: IO ()
main = typeSlow "Hello World\n\nWelcome to the ARVIX system.\n\nCalculating\t\\\b|\b/\b-\b/\b-\bDone."

