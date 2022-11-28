{-# OPTIONS_GHC -Wwarn #-}

import Secret

main :: IO ()
main = do
    -- We can't do this...

    -- print mySecret

    -- and if it was a record we'd have nothing to match on it...

    -- and we can't do this...

    -- let secret = case mySecret of
    --                 (Secret s _) -> (s :: String)
    -- print (secret :: String)

    -- ... so all we can do is guess.

    print $ checkSecret mySecret "a"
    print $ checkSecret mySecret "dontreadme"

    print $ checkSecret myHashedSecret 2
    print $ checkSecret myHashedSecret 1

    -- This might be like a hidden env.