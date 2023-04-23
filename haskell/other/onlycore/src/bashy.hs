{-# OPTIONS_GHC -Wno-unsafe #-}
{-# LANGUAGE Unsafe #-}

import Shell

main ∷ IO ()
main = do
    ls
    cat "/etc/passwd"
