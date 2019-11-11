{-# LANGUAGE OverloadedStrings #-} -- Text can accept strings - no need to pack
{-# LANGUAGE ExtendedDefaultRules #-} -- Stringy stuff can default to text

-- import Control.Monad.Trans (liftIO)

import Database.MongoDB

-- import Data.Text (pack)

-- import Database.MongoDB
main :: IO ()
main = do
    mongoconn <- connect $ host "localhost"
    _ <- access mongoconn master "bob" (insert "bobs" ["name"=:("Jim" :: String)] >> find (select [] "bobs") >>= rest)

    return ()
