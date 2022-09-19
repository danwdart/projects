-- Stolen from https://serokell.io/blog/haskell-type-level-witness
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}

module Main where

import Data.List

data UserPrivilege = Guest | Normal | Admin | SuperUser deriving (Read, Show)

data User = User {
    userId :: Int,
    userName :: String,
    userPrivilege :: UserPrivilege
} deriving (Show)

-- Hmm there's no difference
-- >>> superUser
-- User {userId = 0, userName = "Root", userPrivilege = SuperUser}
--
superUser :: User
superUser = User 0 "Root" SuperUser

-- >>> normalUser
-- User {userId = 1, userName = "Dan", userPrivilege = Normal}
--
normalUser :: User
normalUser = User 1 "Dan" Normal

-- Evil?

-- >>> doSomethingEvil normalUser
-- I'm sorry Dave, I can't let you do that.
--
-- >>> doSomethingEvil superUser
-- Mwahahaha!
--
doSomethingEvil :: User -> IO ()
doSomethingEvil User { userPrivilege = userPrivilege} = case userPrivilege of
    SuperUser -> putStrLn "Mwahahaha!"
    _ -> putStrLn "I'm sorry Dave, I can't let you do that."

-- But what if they forget to switch on case?
-- >>> doSomethingEvil2 normalUser
-- Mwahahaha!
--
doSomethingEvil2 :: User -> IO ()
doSomethingEvil2 _ = putStrLn "Mwahahaha!"

-- Let's have some type safety! How about... smart constructors?

-- now ideally this constructor will be hidden
newtype SmartSuperUser = SmartSuperUser {
    getUser :: User
} deriving (Show)

-- >>> mkSuperUser superUser
-- Just (SmartSuperUser {getUser = User {userId = 0, userName = "Root", userPrivilege = SuperUser}})
--
-- >>> mkSuperUser normalUser
-- Nothing
--
mkSuperUser :: User -> Maybe SmartSuperUser
mkSuperUser user@User { userPrivilege = userPrivilege} = case userPrivilege of
    SuperUser -> Just (SmartSuperUser user)
    _ -> Nothing

-- >>> sequence_ $ doSomethingEvilSmart <$> mkSuperUser superUser
-- Mwahaha!

-- >>> sequence_ $ doSomethingEvilSmart <$> mkSuperUser normalUser
--
doSomethingEvilSmart :: SmartSuperUser -> IO ()
doSomethingEvilSmart _ = putStrLn "Mwahaha!"

-- but that requires too much boilerplate... how about typed?

data UserWithType (ut :: UserPrivilege) = UserWithType {
    userWTId :: Int,
    userWTName :: String
}

deriving instance Show (UserWithType a)

data UserWrapper
  = WrappedGuestUser (UserWithType 'Guest)
  | WrappedNormalUser (UserWithType 'Normal)
  | WrappedAdminUser (UserWithType 'Admin)
  | WrappedSuperUser (UserWithType 'SuperUser)
  deriving Show

data SomeUser where
  SomeUser :: forall a. UserWithType a -> SomeUser

deriving instance Show SomeUser

-- type SUser = forall a. UserWithType a

-- >>> userToUserWithType normalUser
-- UserWithType {userWTId = 1, userWTName = "Dan"}
--
-- >>> userToUserWithType superUser
-- UserWithType {userWTId = 0, userWTName = "Root"}
--

-- >>> :t userToUserWithType superUser
-- userToUserWithType superUser :: UserWithType a
--
userToUserWithType :: User -> UserWithType a
userToUserWithType (User userId userName userPrivilege) = UserWithType userId userName

-- Kind of useless...
-- >>> evilType $ userToUserWithType normalUser
-- Mwahaha
--
evilType :: UserWithType 'SuperUser -> IO ()
evilType _ = putStrLn "Mwahaha"

notEvilType :: UserWithType a -> IO ()
notEvilType _ = putStrLn "Nah."

-- >>> userToSomeUser $ normalUser
-- SomeUser (UserWithType {userWTId = 1, userWTName = "Dan"})
--
userToSomeUser :: User -> SomeUser
userToSomeUser (User userId userName userPrivilege) = SomeUser $ UserWithType userId userName

-- >>> userToWrappedUser normalUser
-- WrappedNormalUser (UserWithType {userWTId = 1, userWTName = "Dan"})
--
-- >>> userToWrappedUser superUser
-- WrappedSuperUser (UserWithType {userWTId = 0, userWTName = "Root"})
--
userToWrappedUser :: User -> UserWrapper
userToWrappedUser (User userId userName userPrivilege) = case userPrivilege of
    Guest -> WrappedGuestUser $ UserWithType userId userName
    Normal -> WrappedNormalUser $ UserWithType userId userName
    Admin -> WrappedAdminUser $ UserWithType userId userName
    SuperUser -> WrappedSuperUser $ UserWithType userId userName

-- >>> evilWrapped $ userToWrappedUser normalUser
-- Nah.
--

-- >>> evilWrapped $ userToWrappedUser superUser
-- Mwahaha
--
evilWrapped :: UserWrapper -> IO ()
evilWrapped uw = case uw of
    WrappedGuestUser ut -> notEvilType ut
    WrappedNormalUser ut -> notEvilType ut
    WrappedAdminUser ut -> notEvilType ut
    WrappedSuperUser ut -> evilType ut

-- Full witness privilege levels

data WitnessPrivilege up where
  WitnessGuest :: WitnessPrivilege 'Guest
  WitnessNormal :: WitnessPrivilege 'Normal
  WitnessAdmin :: WitnessPrivilege 'Admin
  WitnessSuperUser :: WitnessPrivilege 'SuperUser

deriving instance Show (WitnessPrivilege a)

data UserForWitness (up :: UserPrivilege) = UserForWitness
  { userForWitnessId :: Int
  , userForWitnessName :: String
  , userForWitnessPrivilege :: WitnessPrivilege up
  } deriving (Show)

data SomeUserWitnessed where
  SomeUserWitnessed :: UserForWitness a -> SomeUserWitnessed

deriving instance Show SomeUserWitnessed

-- >>> userToWitnessed normalUser
-- SomeUserWitnessed (UserForWitness {userForWitnessId = 1, userForWitnessName = "Dan", userForWitnessPrivilege = WitnessNormal})
--

-- >>> userToWitnessed superUser
-- SomeUserWitnessed (UserForWitness {userForWitnessId = 0, userForWitnessName = "Root", userForWitnessPrivilege = WitnessSuperUser})
--
userToWitnessed :: User -> SomeUserWitnessed
userToWitnessed (User userId userName userPrivilege) = case userPrivilege of
    Guest -> SomeUserWitnessed $ UserForWitness userId userName WitnessGuest
    Normal -> SomeUserWitnessed $ UserForWitness userId userName WitnessNormal
    Admin -> SomeUserWitnessed $ UserForWitness userId userName WitnessAdmin
    SuperUser -> SomeUserWitnessed $ UserForWitness userId userName WitnessSuperUser

-- >>> evilW $ userToWitnessed normalUser
-- Nah.
--
-- >>> evilW $ userToWitnessed superUser
-- Mwahaha
--
evilW :: SomeUserWitnessed -> IO ()
evilW (SomeUserWitnessed user) = case userForWitnessPrivilege user of
    WitnessSuperUser -> evilWitnessed user
    _ -> notEvilWitnessed user

evilWitnessed :: UserForWitness 'SuperUser -> IO ()
evilWitnessed (UserForWitness id name up) = putStrLn "Mwahaha"

notEvilWitnessed :: UserForWitness a -> IO ()
notEvilWitnessed (UserForWitness id name up) = putStrLn "Nah."

main :: IO ()
main = pure ()