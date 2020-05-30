import Text.Regex.TDFA

main :: IO ()
main = do
    print ("BOB" =~ "b" :: Bool)
    print ("BOB" =~ "b" :: Bool)
    print ("BOB" =~ "B." :: String)
    print ("BOB" =~ "B" :: (String, String, String))
    print ("BOB" =~ "B" :: (String, String, String, [String]))
    print ("BOB" =~ "B" :: Int)