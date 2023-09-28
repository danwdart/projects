{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE Trustworthy     #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

import Language.Haskell.TH

main ∷ IO ()
main = putStrLn bob

bob ∷ String
bob = $(stringE =<< runIO (readFile "onlycore.cabal"))
