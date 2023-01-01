{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE Unsafe    #-}
{-# OPTIONS_GHC -Wno-safe -Wno-unsafe #-}

-- import Control.Monad.Trans (liftIO)
import           Database.MongoDB

-- import Data.Text (pack)

-- import Database.MongoDB
main ∷ IO ()
main = do
    mongoconn <- connect $ host "localhost"
    _ <- access mongoconn master "bob" (insert "bobs" ["name" =: ("Jim" :: String)] >> find (select [] "bobs") >>= rest)

    pure ()
