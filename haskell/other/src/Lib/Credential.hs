module Lib.Credential (
    Creds (..),
    printCreds
) where

data Creds = Creds String String deriving (Show)

printCreds :: Creds -> String
printCreds (Creds a b) = "Your username is " ++ a ++ " and your password is " ++ b
