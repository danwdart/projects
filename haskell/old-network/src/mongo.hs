{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE UnicodeSyntax        #-}

-- import Control.Monad.Trans (liftIO)

import           Database.MongoDB

-- import Data.Text (pack)

-- import Database.MongoDB
main ∷ IO ()
main = do
    mongoconn <- connect $ host "localhost"
    _ <- access mongoconn master "bob" (insert "bobs" ["name"=:("Jim" :: String)] >> find (select [] "bobs") >>= rest)

    return ()
