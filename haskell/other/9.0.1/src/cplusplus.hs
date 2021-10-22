{-# LANGUAGE QuasiQuotes     #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE UnicodeSyntax   #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import           Language.C.Inline.Cpp

context cppCtx

using "namespace std"
include "<iostream>"

b ∷ IO CInt
b = [block| int { return 2; } |]

main ∷ IO ()
main = [block| void {
            cout << "Hello, world!" << endl;
        } |]
