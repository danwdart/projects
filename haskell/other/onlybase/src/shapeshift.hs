-- Shapeshift a record based on a user's type field.
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE GHC2024 #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}

module Main where

import Data.Functor.Identity
import Data.Functor.Const
import Data.Kind
import Data.String
-- import Data.Void

data UserType = Normal | OrgAdmin | Super
    deriving stock (Eq, Show)

newtype ID = ID Int
    deriving stock (Eq, Show)
    deriving (Num) via Int

newtype Name = Name String
    deriving stock (Eq, Show)
    deriving (IsString) via String

{-}
data UserFromDB = UserFromDB {
    userId :: Int,
    name :: String,
    userType :: UserType
} deriving (Eq, Show)

data User (userType :: UserType) = User {
    _id :: Int,
    _name :: String
}
-}

{-
data User f = User {
    userId :: f Int,
    name :: f String,
    userType :: f UserType
}
-}

-- how about per field of this?

data HKDUser f = HKDUser {
    userId :: HKD f ID,
    name :: HKD f Name,
    userType :: HKD f UserType
}

deriving instance (
    Eq (HKD f String),
    Eq (HKD f Name),
    Eq (HKD f Int),
    Eq (HKD f ID),
    Eq (HKD f UserType)
    ) => Eq (HKDUser f)

deriving instance (
    Show (HKD f String),
    Show (HKD f Name),
    Show (HKD f Int),
    Show (HKD f ID),
    Show (HKD f UserType)
    ) => Show (HKDUser f)

newtype HideUserType a = HideUserType a

type family HKD (f :: Type -> Type) (a :: Type) :: Type where
    HKD Identity a = a
    HKD HideUserType UserType = Maybe UserType
    HKD HideUserType a = a
    HKD (Const b) _ = b
    HKD f a = f a

newtype MakeOptionalType a = MakeOptionalType a

type family HKDOptional (f :: Type -> Type) (optionalType :: Type) (a :: Type) :: Type where
    HKDOptional Identity _ a = a
    HKDOptional MakeOptionalType optionalType optionalType = Maybe optionalType
    HKDOptional MakeOptionalType _ a = a
    HKDOptional (Const b) _ _ = b
    HKDOptional f _ a = f a

-- newtype FromDB a = FromDB a


data HKDOptionalUser f t = HKDOptionalUser {
    opuuid :: HKDOptional f t ID,
    opname :: HKDOptional f t Name,
    opuserType :: HKDOptional f t UserType
}

deriving instance (
    Eq (HKDOptional f t String),
    Eq (HKDOptional f t Name),
    Eq (HKDOptional f t Int),
    Eq (HKDOptional f t ID),
    Eq (HKDOptional f t UserType)
    ) => Eq (HKDOptionalUser f t)

deriving instance (
    Show (HKDOptional f t String),
    Show (HKDOptional f t Name),
    Show (HKDOptional f t Int),
    Show (HKDOptional f t ID),
    Show (HKDOptional f t UserType)
    ) => Show (HKDOptionalUser f t)

fromDB :: HKDUser Identity
fromDB = HKDUser {
    userId = 123,
    name = "Bob",
    userType = Normal
}

-- >>> fromDB
-- HKDUser {userId = ID 123, name = Name "Bob", userType = Normal}
--

realUser :: HKDUser HideUserType
realUser = HKDUser {
    userId = 1,
    name = "Bob",
    userType = Nothing
}

-- >>> realUser
-- HKDUser {userId = ID 1, name = Name "Bob", userType = Nothing}
--

realUser2 :: HKDOptionalUser MakeOptionalType UserType
realUser2 = HKDOptionalUser {
    opuuid = 1,
    opname = "Bob",
    opuserType = Nothing
}

-- >>> realUser2
-- HKDOptionalUser {opuuid = 1, opname = "Bob", opuserType = Nothing}
--

-- ???
realUser3 :: HKDOptionalUser MakeOptionalType ID
realUser3 = HKDOptionalUser {
    opuuid = Just 1,
    opname = "Bob",
    opuserType = Normal
}

-- >>> realUser3
-- HKDOptionalUser {opuuid = 1, opname = "Bob", opuserType = Normal}
--

realUser4 :: HKDOptionalUser MakeOptionalType Int
realUser4 = HKDOptionalUser {
    opuuid = 1,
    opname = "Bob",
    opuserType = Normal
}

-- >>> realUser4
-- HKDOptionalUser {opuuid = Just 1, opname = "Bob", opuserType = Normal}
--

realUser5 :: HKDOptionalUser MakeOptionalType String
realUser5 = HKDOptionalUser {
    opuuid = 1,
    opname = "Bob",
    opuserType = Normal
}

-- >>> realUser5
-- HKDOptionalUser {opuuid = 1, opname = Just "Bob", opuserType = Normal}
--

realUser6 :: HKDOptionalUser MakeOptionalType Name
realUser6 = HKDOptionalUser {
    opuuid = 1,
    opname = Just "Bob",
    opuserType = Normal
}

-- >>> realUser6
-- HKDOptionalUser {opuuid = 1, opname = "Bob", opuserType = Normal}
--


main :: IO ()
main = pure ()