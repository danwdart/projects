module Auth (
    AuthenticationResult,
    authenticate
) where

import Data.Email
import Data.Name
import Data.Password
import Data.User

type AuthenticationResult = Either String User

-- >>> authenticate "bob@bob.com" "password1"
-- Right (User {email = "bob@bob.com", password = "password1", name = DuoName "Bob" "Frog"})

authenticate ∷ Email → Password → AuthenticationResult
-- authenticate email password = Left "Sorry wrong password"
authenticate sEmail sPassword = Right User {
    email = sEmail,
    password = sPassword,
    name = DuoName "Bob" "Frog"
}
