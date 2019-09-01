module Lib.Data.User (
    User (..)
) where

import Lib.Data.Email
import Lib.Data.Password
import Lib.Data.Name

data User = User {
    email :: Email,
    password :: Password,
    name :: Name
} deriving (Show)