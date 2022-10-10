
{-# LANGUAGE Unsafe #-}
{-# LANGUAGE UnboxedTuples #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-unused-top-binds #-}

import GHC.IO

-- >>> :t IO
-- IO
--   :: (GHC.Prim.State# GHC.Prim.RealWorld
--       -> (# GHC.Prim.State# GHC.Prim.RealWorld, a #))
--      -> IO a
--

-- Warning: RealWorld has no constructors!

tweagrae :: IO ()
tweagrae = IO $ \realWorld ->
    case putStrLn "hello" of
        IO fun1 -> case putStrLn "goodbye" of
            IO fun2 -> case fun2 realWorld of
                (# _realWorld, _ #) -> case fun1 realWorld of
                    (# _, _ #) -> fun1 realWorld

otherIO :: IO ()
otherIO = IO $ \realWorld ->
    case putStrLn "Hi" of
        IO printsHi -> case printsHi realWorld of
            (# _, _ #) -> case putStrLn "Hey" of
                IO printsHey -> case printsHey realWorld of
                    (# _, _ #) -> case getLine of
                        IO getsLine -> case getsLine realWorld of
                            (# _, str #) -> case putStrLn str of
                                IO printsInputtedStr -> case printsInputtedStr realWorld of
                                    (# _, () #) -> case printsHey realWorld of
                                        (# _, () #) -> printsHi realWorld

-- There is functionally no difference in the real world here.
main :: IO ()
main = do
    tweagrae
    otherIO