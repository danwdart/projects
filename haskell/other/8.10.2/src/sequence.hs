import           Lib.Seq

main :: IO ()
main = getLine >>>= putStrLn >>>= putStrLn >>= putStrLn
