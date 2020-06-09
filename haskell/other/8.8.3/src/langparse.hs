{-# LANGUAGE RankNTypes    #-}
{-# LANGUAGE UnicodeSyntax #-}

import Language.JavaScript.Parser
import Language.C

testFile ∷ String
testFile = "(function main(a, b) { console.log(a + b); })(1, 2);"

main ∷ IO ()
main = do
    print $ readJs testFile
    print =<< parseCFilePre "/usr/include/stdio.h"