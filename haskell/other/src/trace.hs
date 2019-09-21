import Debug.Trace
import Control.Monad.Trans.State.Lazy

st :: StateT Int IO Int
st = do
    traceM "Hi" -- no dupe...
    put 2
    r <- get
    traceShowM r
    return 1

main :: IO ()
main = do
    r <- trace "ST: " $ runStateT st 1 -- no dupe!
    traceShowM r
    traceIO "this is where we were"
