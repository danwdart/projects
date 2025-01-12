module Main (main) where

import Control.Monad      (void)
import Control.Monad.Cont

-- ContT doesn't require the wrapping m to actually even be a monad.

-- Let's just make a functor for a sec here...
data MyFunctor a = MyFunctor a deriving stock (Functor, Show)

-- Is there anything interesting I can do with this?
fnMon ∷ ContT Int MyFunctor Int
fnMon = callCC $ \_ -> do
    void $ ContT (\_ -> MyFunctor 1)
    pure 1

main ∷ IO ()
main = do
    let result = runContT fnMon $ \_ -> MyFunctor 0
    print result
