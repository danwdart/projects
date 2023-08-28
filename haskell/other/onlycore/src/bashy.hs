{-# OPTIONS_GHC -Wno-unsafe #-}
{-# LANGUAGE Safe #-}

import Shell

main ∷ IO ()
main = do
    ls
    cat "/etc/passwd"
