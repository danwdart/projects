module Lib.Auth (
    AuthenticationResult,
    authenticate
) where

import Lib.Data.Name
import Lib.Data.Email
import Lib.Data.Password
import Lib.Data.User

type AuthenticationResult = Either String User

authenticate :: Email -> Password -> AuthenticationResult
-- authenticate email password = Left "Sorry wrong password"
authenticate email password = Right User {
    email = email,
    password = password,
    name = DuoName "Bob" "Frog"
}