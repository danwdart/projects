{-# LANGUAGE UnicodeSyntax #-}
module Lib.Auth (
    AuthenticationResult,
    authenticate
) where

import           Lib.Data.Email
import           Lib.Data.Name
import           Lib.Data.Password
import           Lib.Data.User

type AuthenticationResult = Either String User

authenticate ∷ Email → Password → AuthenticationResult
-- authenticate email password = Left "Sorry wrong password"
authenticate sEmail sPassword = Right User {
    email = sEmail,
    password = sPassword,
    name = DuoName "Bob" "Frog"
}
