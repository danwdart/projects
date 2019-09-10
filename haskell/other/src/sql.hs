{-# LANGUAGE OverloadedStrings #-} -- Text can accept strings - no need to pack
{-# LANGUAGE ExtendedDefaultRules #-} -- Stringy stuff can default to text

import Control.Monad.Trans (liftIO)

import Database.HDBC
import Database.HDBC.MySQL

import Data.Text (pack)

-- import Database.MongoDB
main = do
    mysqlconn <- connectMySQL $ MySQLConnectInfo "172.18.0.3" "sm" "sm" "sm" 3306 "" Nothing
    ts <- quickQuery mysqlconn "show tables;" []

    return ()