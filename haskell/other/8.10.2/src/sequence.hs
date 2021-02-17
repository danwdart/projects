{-# LANGUAGE UnicodeSyntax #-}
import           Lib.Seq

with :: String -> IO ()
with a = return a >>>= putStrLn >>>= putStrLn >>= putStrLn

main ∷ IO ()
main = do
    getLine >>>= putStrLn >>>= putStrLn >>= putStrLn
    with "AAA"