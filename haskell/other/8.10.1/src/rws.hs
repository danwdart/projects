{-# LANGUAGE MultiParamTypeClasses, PackageImports #-}

import Control.Monad.IO.Class
import "mtl" Control.Monad.Reader (MonadReader())
import "mtl" Control.Monad.State (MonadState())
import Control.Monad.Trans.RWS
import "mtl" Control.Monad.Writer (MonadWriter())

class (
    Monad m,
    MonadReader r m,
    MonadState s m,
    MonadWriter w m,
    MonadIO m,
    MonadFail m
    ) => MonadApp r w s m a

data App r w s m a = App {
    version :: Int,
    author :: String,
    runApp :: r -> s -> m (a, s, w)
}

type AppRead = String
type AppState = Int
type AppWriter = [String]
type AppReturn = Char

stuff :: RWS AppRead AppWriter AppState AppReturn
stuff = do
    tell ["hi"]
    put 2
    asks (!! 0)

stuff2 :: MonadApp r w s m a => m (a, s, w)
stuff2 = do
    tell ["hey"]
    liftIO . print $ "AAA"
    put 2
    asks (!! 0)

main :: IO ()
main = do
    print $ runRWS stuff "aeiou" 1
    print =<< runRWST stuff2 "aeiou" 1

