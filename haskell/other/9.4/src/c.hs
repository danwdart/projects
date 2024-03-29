{-# LANGUAGE QuasiQuotes     #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE Trustworthy     #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Main (main) where

import Language.C.Inline qualified as C

C.include "<math.h>"

main ∷ IO ()
main = do
  x <- [C.exp| double{ cos(1) } |]
  print x
