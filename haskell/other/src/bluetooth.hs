import Data.Function
import Data.Functor
import Network.Bluetooth

main :: IO ()
main =
    allAdapters >>= print
    --print allAdapters <&> discover
