{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}

import Language.C.Inline.Cpp

context cppCtx

using "namespace std"
include "<iostream>"

b :: IO CInt
b = [block| int { return 2; } |]

main :: IO ()
main = [block| void {
            cout << "Hello, world!" << endl;
        } |]