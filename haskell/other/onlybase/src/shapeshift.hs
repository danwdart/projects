-- Shapeshift a record based on a user's type field.
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE GHC2024 #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main (main) where

import Data.Functor.Identity
import Data.Functor.Const
import Data.Kind
import Data.String
-- import Data.Void
import GHC.TypeNats -- TypeLits

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

newtype HideUserType a = HideUserType a

type family HKD (f :: Type -> Type) (a :: Type) :: Type where
    HKD Identity a = a
    HKD HideUserType UserType = Maybe UserType
    HKD HideUserType a = a
    HKD (Const b) _ = b
    HKD f a = f a

data HKDUser f = HKDUser {
    userId :: HKD f ID,
    name :: HKD f Name,
    userType :: HKD f UserType
}

deriving instance (
    Eq (HKD f Name),
    Eq (HKD f ID),
    Eq (HKD f UserType)
    ) => Eq (HKDUser f)

deriving instance (
    Show (HKD f Name),
    Show (HKD f ID),
    Show (HKD f UserType)
    ) => Show (HKDUser f)

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
    Eq (HKDOptional f t Name),
    Eq (HKDOptional f t ID),
    Eq (HKDOptional f t UserType)
    ) => Eq (HKDOptionalUser f t)

deriving instance (
    Show (HKDOptional f t Name),
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
-- (Error while loading modules for evaluation)
-- [1 of 2] Compiling Main             ( /home/dwd/code/mine/multi/projects/haskell/other/onlybase/src/shapeshift.hs, interpreted )
-- /home/dwd/code/mine/multi/projects/haskell/other/onlybase/src/shapeshift.hs:115:5: error: [GHC-58481]
--     parse error on input ‘)’
-- <BLANKLINE>
-- Failed, no modules to be reloaded.
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

-- now can we index it?


-- at this point it's just a static map

type family HKDIndexed (n :: Nat) (f :: Type -> Type) (a :: Type) :: Type where
    HKDIndexed 2 _ a = Maybe a
    HKDIndexed _ Identity a = a
    HKDIndexed _ (Const b) _ = b
    HKDIndexed _ f a = f a


data HKDIndexedUser f = HKDIndexedUser {
    ixuuid :: HKDIndexed 1 f ID,
    ixname :: HKDIndexed 2 f Name,
    ixuserType :: HKDIndexed 3 f UserType
}

deriving instance (Show (HKDIndexed 1 f ID), Show (HKDIndexed 3 f UserType)) => Show (HKDIndexedUser f)

exampleIndexed :: HKDIndexedUser Identity
exampleIndexed = HKDIndexedUser {
    ixuuid = 1,
    ixname = Just "bob",
    ixuserType = Normal
}

-- >>> exampleIndexed
-- HKDIndexedUser {ixuuid = ID 1, ixname = Just (Name "bob"), ixuserType = Normal}
--

type family HKDNamed n (f :: Type -> Type) (a :: Type) :: Type where -- Symbol? String?
    HKDNamed "Name" _ a = Maybe a
    HKDNamed _ Identity a = a
    HKDNamed _ (Const b) _ = b
    HKDNamed _ f a = f a

data HKDNamedUser f = HKDNamedUser {
    nameduuid :: HKDNamed "ID" f ID,
    namedname :: HKDNamed "Name" f Name,
    nameduserType :: HKDNamed "UserType" f UserType
}

deriving instance (Show (HKDNamed "UserType" f UserType), Show (HKDNamed "ID" f ID)) => Show (HKDNamedUser f)

exampleNamed :: HKDNamedUser Identity
exampleNamed = HKDNamedUser {
    nameduuid = 1,
    namedname = Just "bob",
    nameduserType = Normal
}

-- >>> exampleNamed
-- HKDNamedUser {nameduuid = ID 1, namedname = Just (Name "bob"), nameduserType = Normal}
--

main :: IO ()
main = pure ()