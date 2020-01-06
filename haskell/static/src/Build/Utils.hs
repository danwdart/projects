module Build.Utils (mkdirp) where

import System.Directory

mkdirp :: String -> IO ()
mkdirp = createDirectoryIfMissing True