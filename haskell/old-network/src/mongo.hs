{-# LANGUAGE OverloadedStrings #-} -- Text can accept strings - no need to pack
{-# LANGUAGE ExtendedDefaultRules #-} -- Stringy stuff can default to text

import Control.Monad.Trans (liftIO)

import Database.MongoDB

import Data.Text (pack)

-- import Database.MongoDB
main = do
    mongoconn <- connect $ host "localhost"
    access mongoconn master "bob" (insert "bobs" ["name"=:"Jim"] >> find (select [] "bobs") >>= rest)

    return ()
