import           Data.Profunctor
import           Control.Monad.IO.Class
import           Control.Monad.Reader

-- todo contra on its own

r :: ReaderT String IO ()
r = ask >>= liftIO . putStrLn

sr :: Star IO String ()
sr = Star $ runReaderT r

modifiedSr :: Show a => Star IO a String
modifiedSr = dimap show (const "Returned Reader") sr

modifiedSr2 :: Star IO Int String
modifiedSr2 = dimap (+1) (<> "!") modifiedSr

f :: String -> IO ()
f = putStrLn

sf :: Star IO String ()
sf = Star f

modifiedSf :: Show a => Star IO a String
modifiedSf = dimap show (const "Returned Function") sf

modifiedSf2 :: Star IO Int String
modifiedSf2 = dimap (+1) (<> "!") modifiedSf

main ∷ IO ()
main = do
    runStar sr "Hi Reader"
    runStar sf "Hi Function"
    r <- runStar modifiedSr 123
    print r
    f <- runStar modifiedSf 456
    print f
    r2 <- runStar modifiedSr2 123
    print r2
    f2 <- runStar modifiedSf2 456
    print f2
    