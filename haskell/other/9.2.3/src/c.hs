{-# LANGUAGE QuasiQuotes     #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

import qualified Language.C.Inline as C

C.include "<math.h>"

main ∷ IO ()
main = do
  x <- [C.exp| double{ cos(1) } |]
  print x
