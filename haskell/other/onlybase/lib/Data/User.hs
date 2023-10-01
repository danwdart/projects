{-# LANGUAGE Safe #-}

module Data.User (
    User (..)
) where

import Data.Email
import Data.Name
import Data.Password

data User = User {
    email    :: Email,
    password :: Password,
    name     :: Name
} deriving stock (Show)
