{-# OPTIONS_GHC -Wno-unsafe #-}
{-# LANGUAGE Safe #-}

import System.Directory
import System.IO

main ∷ IO ()
main = do
    hd <- getHomeDirectory
    putStrLn hd
    (tempFile, handle) <- openTempFile "." "temp"
    hClose handle
    writeFile tempFile "Temp"
    fileContents <- readFile tempFile
    putStrLn fileContents
    hPutStrLn stderr "This will go to stderr."
    withFile tempFile ReadWriteMode $ \h -> do
        hPutStrLn h "Next line"
        hPutStr h "Another string"
    fc <- readFile tempFile
    putStrLn fc
    size <- getFileSize tempFile
    print size
    removeFile tempFile
