{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Safe #-}

module Data.Thriple.Things where

import Data.Bifunctor
import Data.Either.Validation
import Data.Functor.Const
-- import Data.Functor.Identity
-- import Data.HKD
import Data.HKD.Generic
import Data.List              qualified as L
import Data.Text              (Text)
import Data.Text              qualified as T
import Data.Thriple
import GHC.Generics
import Text.Read

type DBCol = Text

data DBField = VarChar Text | MediumInt Int | TinyInt Bool

stringToBool ∷ String → Either String Bool
stringToBool x
    | x == "True" = Right True
    | x == "TRUE" = Right True
    | x == "true" = Right True
    | x == "t" = Right True
    | x == "y" = Right True
    | x == "yes" = Right True
    | x == "on" = Right True
    | x == "False" = Right False
    | x == "FALSE" = Right False
    | x == "f" = Right False
    | x == "n" = Right False
    | x == "no" = Right False
    | x == "off" = Right False
    | otherwise = Left $ "I don't know what " <> x <> " means!"


type ErrMsg = Text

type ErrMsgs = [ErrMsg]

newtype EnvParser a = EnvParser {
    runEnvParser :: String → Validation ErrMsgs a
} deriving stock (Generic)

newtype DBParser a = DBParser {
    runDBParser :: DBField → Validation ErrMsgs a
} deriving stock (Generic)

descr ∷ Thriple (Const Text)
descr = Thriple {
    a = "The A field",
    b = "The B field",
    c = "The C field"
}

errs ∷ Thriple (Const Text)
errs = Thriple {
    a = "Can't find the A field",
    b = "Can't find the B field",
    c = "Can't find the C field"
}

cols ∷ Thriple (Const DBCol)
cols = Thriple {
    a = "colA",
    b = "colB",
    c = "colC"
}

colLoc ∷ Thriple (Const Int)
colLoc = Thriple {
    a = 0,
    b = 1,
    c = 2
}

envVars ∷ Thriple (Const String) -- TODO OsString
envVars = Thriple {
    a = "ENV_INT_A",
    b = "ENV_TEXT_B",
    c = "ENV_BOOL_C"
}

envParser ∷ Thriple EnvParser
envParser = Thriple {
    a = EnvParser $ first (L.singleton . T.pack) . eitherToValidation . readEither,
    b = EnvParser $ first (L.singleton . T.pack) . Success . T.pack,
    c = EnvParser $ first (L.singleton . T.pack) . eitherToValidation . stringToBool
}

dbParser ∷ Thriple DBParser
dbParser = Thriple {
    a = DBParser $ \case
        MediumInt x -> Success x
        _ -> Failure ["a is not a MediumInt"],
    b = DBParser $ \case
        VarChar x -> Success x
        _ -> Failure ["b is not a VarChar"],
    c = DBParser $ \case
        TinyInt x -> Success x
        _ -> Failure ["c is not a TinyInt"]
}

dbTable ∷ Thriple (Const DBField)
dbTable = Thriple {
    a = Const $ MediumInt 10,
    b = Const $ VarChar "It's A",
    c = Const $ TinyInt True
}

getFromT ∷ Thriple (Validation ErrMsgs)
getFromT = hzipWith (\p f -> runDBParser p $ getConst f) dbParser dbTable
