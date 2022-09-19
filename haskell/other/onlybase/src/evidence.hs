-- Stolen from https://serokell.io/blog/haskell-type-level-witness

{-# LANGUAGE DataKinds #-}

module Main where

data UserType = Normal | Admin | SuperUser

data User = User {
    userId :: Int,
    userName :: String,
    userType :: UserType
}

doSomethingEvil :: User -> IO ()
doSomethingEvil User { userType = userType} = case userType of
    SuperUser -> putStrLn "Mwahahaha!"
    _ -> putStrLn "I'm sorry Dave, I can't let you do that."

-- But what if they forget to switch on case?

doSomethingEvil2 :: User -> IO ()
doSomethingEvil2 _ = putStrLn "Mwahahaha!"

-- Let's have some type safety! How about... smart constructors?

-- now ideally this constructor will be hidden
newtype SmartSuperUser = SmartSuperUser {
    getUser :: User
}

-- here's a smart constructor
mkSuperUser :: User -> Maybe SmartSuperUser
mkSuperUser user@User { userType = userType} = case userType of
    SuperUser -> Just (SmartSuperUser user)
    _ -> Nothing

doSomethingEvilSmart :: SmartSuperUser -> IO ()
doSomethingEvilSmart _ = putStrLn "Mwahaha!"

-- but that requires too much boilerplate... how about typed?

-- err... can't do that
getUserWithType :: User -> UserWithType a
getUserWithType = undefined

data UserWithType (ut :: UserType) = UserWithType {
    userWTId :: Integer,
    userWTName :: String
}

main :: IO ()
main = do
    let superUser = User 0 "Root" SuperUser
    let normalUser = User 1 "Dan" Normal

    putStrLn "doSomethingEvil normalUser"
    doSomethingEvil normalUser

    putStrLn "doSomethingEvil superUser"
    doSomethingEvil superUser

    putStrLn "doSomethingEvil2 normalUser: incorrect behaviour"
    doSomethingEvil2 normalUser

    putStrLn "doSomethingEvil2 superUser"
    doSomethingEvil2 superUser

    putStrLn "Case match on smart constructor (normal)"
    case mkSuperUser normalUser of
        Just smartSuperUser -> doSomethingEvilSmart smartSuperUser
        _ -> putStrLn "Can't do that."
    
    putStrLn "Case match on smart constructor (super)"
    case mkSuperUser superUser of
        Just smartSuperUser -> doSomethingEvilSmart smartSuperUser
        _ -> putStrLn "Can't do that."