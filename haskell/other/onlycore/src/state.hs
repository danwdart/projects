module Main (main) where

import Control.Monad (void)
import Control.Monad.State
import Data.Foldable

type MyState = State [Int] Int

state1 ∷ Int → MyState
state1 val = state (\s -> (val, 1:s))

stateModifier ∷ Int → MyState
stateModifier val = state (val + 1,)

stateProcessByFns ∷ MyState
stateProcessByFns = state1 1 >>= stateModifier

stateProcessByDo ∷ MyState
stateProcessByDo = do
    x <- state1 1
    void $ stateModifier x
    void $ stateModifier x
    void get
    void $ put [1, 2]
    pure 1

main ∷ IO ()
main = traverse_ print [
    runState stateProcessByFns [],
    runState stateProcessByDo [] ]
