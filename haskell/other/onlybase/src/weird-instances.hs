{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies      #-}
{-# OPTIONS_GHC -Wno-orphans #-}

import MagicString ()

main ∷ IO ()
main = do
    "hi" "hey"
