{-# LANGUAGE TupleSections #-}
{-# LANGUAGE UnicodeSyntax #-}

import           Control.Monad.State

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
    _ <- stateModifier x
    _ <- stateModifier x
    _ <- get
    _ <- put [1, 2]
    return 1

main ∷ IO ()
main = mapM_ print [
    runState stateProcessByFns [],
    runState stateProcessByDo [] ]
