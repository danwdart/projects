{-# LANGUAGE RebindableSyntax #-}
{-# LANGUAGE UnicodeSyntax    #-}

import           Prelude hiding (return, (>>), (>>=))

ints ∷ Int
ints = do
    1
    2
    3
    4
    5
    where (>>) = (+)

main ∷ IO ()
main = print ints
