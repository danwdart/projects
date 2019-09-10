import System.Directory

ls :: IO ()
ls = getCurrentDirectory >>= listDirectory >>= mapM_ putStrLn

cat :: String -> IO ()
cat s = readFile s >>= putStrLn

main :: IO ()
main = undefined
