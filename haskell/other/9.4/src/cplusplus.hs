{-# LANGUAGE QuasiQuotes     #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE Trustworthy     #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-unused-top-binds #-}

module Main (main) where

import Language.C.Inline.Cpp

context cppCtx

using "namespace std"
include "<iostream>"

b ∷ IO CInt
b = [block| int { return 2; } |]

main ∷ IO ()
main = [block| void {
            cout << "Hello, world!" << endl;
        } |]
