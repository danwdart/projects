{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings    #-}

import           Database.HDBC
import           Database.HDBC.MySQL

main :: IO ()
main = do
    mysqlconn <- connectMySQL $ MySQLConnectInfo "172.18.0.3" "sm" "sm" "sm" 3306 "" Nothing
    ts <- quickQuery mysqlconn "show tables;" []
    print ts
