{-# LANGUAGE Safe #-}

module Credential (
    Creds (..),
    printCreds
) where

data Creds = Creds String String deriving stock (Show)

-- >>> printCreds $ Creds "user" "pass"
-- "Your username is user and your password is pass"

printCreds ∷ Creds → String
printCreds (Creds a b) = "Your username is " <> (a <> (" and your password is " <> b))
