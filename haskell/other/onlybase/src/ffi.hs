{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-} -- ???

-- import Foreign.Ptr
-- import Foreign.ForeignPtr
import           Foreign.C.String
import           Foreign.C.Types
import           Foreign.Marshal.Alloc
-- import System.IO

-- This is why we're unsafe - but I trust it so we're good
foreign import ccall "exp" c_exp1 :: Double → Double
-- foreign import ccall "&exp" a_exp :: FunPtr (Double -> Double)
-- foreign import ccall "dynamic" mkFun :: FunPtr (Double -> Double) -> (Double -> Double)
foreign import ccall "printf" c_printf :: CString → IO CInt
foreign import ccall "printf" c_printf2 :: CString → CString → IO CInt
foreign import ccall "sprintf" c_sprintf2 :: CString → CString → CString → IO CInt


-- c_exp :: Double -> Double
-- c_exp = mkFun a_exp

-- foreign import ccall "wrapper" createAddPtr :: (Int -> Int) -> IO (FunPtr (Int -> Int))

-- wrapperFunPtr = pure (+) >>= createAddPtr >>= {- do stuff >>= -} freeHaskellFunPtr

--memAlloca = do
--    allocaBytes 128 $ \ptr -> do
--        print ptr
        -- do stuff with the pointer ptr...
        -- ...
        -- do not pure "ptr" in any way because it will become an invalid pointer
    -- here the 128 bytes have been released and should not be accessed

-- lowLevelAlloca = do
--     ptr <- mallocBytes 128
    -- do stuff with the pointer ptr...
    -- ...
--     free ptr
    -- here the 128 bytes have been released and should not be accessed

-- foreignPtrAlloc = do
--     ptr <- mallocForeignPtrBytes 128
--     print ptr
    -- do stuff with the pointer ptr...
    -- ...
    --
    -- ptr is freed when it is collected

cFlush ∷ IO CInt
cFlush = newCString "\n" >>= c_printf

main ∷ IO ()
main = do
    print $ c_exp1 0.1
    _ <- newCString "Bob\n" >>= c_printf
    param1 <- newCString "My name is %s."
    param2 <- newCString "Dan"
    putStrLn "Printing..."
    res <- c_printf2 param1 param2
    _ <- cFlush
    putStrLn "Result was..."
    print res
    putStrLn "And again..."
    res2 <- c_printf param2
    _ <- cFlush
    putStrLn "Result was..."
    print res2
    putStrLn "Yeah?"
    buf <- mallocBytes 32
    putStrLn "Malloced"
    bW <- c_sprintf2 buf param1 param2
    putStrLn "Well..."
    d <- peekCString buf -- sprintf just put it in!
    putStrLn "So it's..."
    putStrLn d
    free param1
    free param2
    free buf
    putStrLn "So we wrote..."
    print bW
    putStrLn "All done."
