{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE Unsafe               #-}
{-# OPTIONS_GHC -Wno-safe -Wno-unsafe #-}

module Main (main) where

import Control.Monad (void)
-- import Control.Monad.Trans (liftIO)
import Database.MongoDB

-- import Data.Text (pack)

-- import Database.MongoDB
main ∷ IO ()
main = do
    mongoconn <- connect $ host "localhost"
    void $ access mongoconn master "bob" (insert "bobs" ["name" =: ("Jim" :: String)] >> find (select [] "bobs") >>= rest)

    pure ()
