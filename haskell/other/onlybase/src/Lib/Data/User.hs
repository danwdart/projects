module Lib.Data.User (
    User (..)
) where

import           Lib.Data.Email
import           Lib.Data.Name
import           Lib.Data.Password

data User = User {
    email    :: Email,
    password :: Password,
    name     :: Name
} deriving (Show)
