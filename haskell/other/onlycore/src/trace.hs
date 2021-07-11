{-# LANGUAGE UnicodeSyntax #-}
import           Control.Monad.Trans.State.Lazy
import           Debug.Trace

st ∷ StateT Int IO Int
st = do
    traceM "Hi" -- no dupe...
    put 2
    r <- get
    traceShowM r
    pure 1

main ∷ IO ()
main = do
    r <- trace "ST: " $ runStateT st 1 -- no dupe!
    traceShowM r
    traceIO "this is where we were"
