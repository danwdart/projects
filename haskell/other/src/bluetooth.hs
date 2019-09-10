import Data.Function
import Data.Functor
import Network.Bluetooth

main :: IO ()
main = do
    allAdapters >>= print
    --print allAdapters <&> discover