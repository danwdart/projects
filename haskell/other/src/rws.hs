import Control.Monad.IO.Class
import qualified Control.Monad.RWS as RWS
import qualified Control.Monad.Trans.RWS as RWST

stuff :: RWS.RWS String [String] Int Char
stuff = do
    RWS.tell ["hi"]
    RWS.put 2
    RWS.asks (!! 0)

stuff2 :: RWST.RWST String [String] Int IO Char
stuff2 = do
    RWST.tell ["hey"]
    liftIO . print $ "AAA"
    RWST.put 2
    RWST.asks (!! 0)

main :: IO ()
main = do
    print $ RWS.runRWS stuff "aeiou" 1
    print =<< RWST.runRWST stuff2 "aeiou" 1