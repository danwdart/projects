import           Network.Bluetooth

main :: IO ()
main = do
    allAdapters >>= print
    allAdapters >>= mapM discover >>= print
