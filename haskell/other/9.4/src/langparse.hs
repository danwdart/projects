{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wno-safe -Wno-unsafe #-}

import           Language.C
import           Language.JavaScript.Parser

testFile ∷ String
testFile = "(function main(a, b) { console.log(a + b); })(1, 2);"

main ∷ IO ()
main = do
    print $ readJs testFile
    print =<< parseCFilePre "/usr/include/stdio.h"
