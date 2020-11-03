{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wno-type-defaults #-}

import           Data.Functor.Contravariant

main ∷ IO ()
main = do
    print $ getOp ((++"b") >$< Op show) "Bob"
    print $ getPredicate ((+1) >$< Predicate (==2)) 1
