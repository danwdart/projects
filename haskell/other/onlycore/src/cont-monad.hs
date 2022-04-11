{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE UnicodeSyntax #-}

import           Control.Monad.Trans.Cont

-- ContT doesn't require the wrapping m to actually even be a monad.

-- Let's just make a functor for a sec here...
data MyFunctor a = MyFunctor a deriving (Functor, Show)

-- Is there anything interesting I can do with this?
fnMon :: ContT Int MyFunctor Int
fnMon = callCC $ \_ -> do
    _ <- ContT (\_ -> MyFunctor 1)
    pure 1

main ∷ IO ()
main = do
    let result = runContT fnMon $ \_ -> MyFunctor 0
    print result