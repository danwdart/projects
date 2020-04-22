import Control.Monad.IO.Class
import qualified Control.Monad.RWS
import qualified Control.Monad.Trans.RWS

stuff :: RWS String [String] Int Char
stuff = do
    tell ["hi"]
    put 2
    asks (!! 0)

stuff2 :: RWST String [String] Int IO Char
stuff2 = do
    tell ["hey"]
    liftIO . print $ "AAA"
    put 2
    asks (!! 0)

main :: IO ()
main = do
    print $ runRWS stuff "aeiou" 1
    print =<< runRWST stuff2 "aeiou" 1