{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Exception

newtype DBConnectionInfo = DBConnectionInfo String
    deriving Show

newtype RowId = RowId Int
    deriving stock (Show, Eq)
    -- deriving (Num) -- only need fromInteger so nm

data DBRow = DBRow {
    dbRowId :: RowId,
    dbRowName :: String
} deriving stock (Show)

sampleRow :: DBRow
sampleRow = DBRow (RowId 1) "Datum"

newtype Url = Url String
    deriving Show

dbConn :: DBConnectionInfo
dbConn = DBConnectionInfo "DB Conn Info"

rowId :: RowId
rowId = RowId 123

data NonsenseException = NonsenseException String | UnexpectedException
    deriving stock (Show)
    deriving anyclass (Exception)

formatRow :: DBRow -> Either NonsenseException String
formatRow DBRow { dbRowId = RowId _, dbRowName = dbRowName' }
    | rowId == RowId 0 = Left $ NonsenseException dbRowName'
    | rowId == RowId 3 = Left UnexpectedException
    | otherwise = Right $ "The row ID was " <> show rowId <> " and the row name was " <> dbRowName'

data DBException = RowNotFoundException RowId | DBConnectionException DBConnectionInfo
    deriving stock (Show)
    deriving anyclass (Exception)

getRow :: Int -> Either DBException DBRow
getRow id'
    | id' == 2 = Left $ RowNotFoundException (RowId 2)
    | id' == 0 = Left $ DBConnectionException dbConn
    | otherwise = Right sampleRow { dbRowId = RowId id' }

data ClientException = NotFoundException Url | InternalServerError
    deriving stock (Show)
    deriving anyclass (Exception)

-- TODO refactor first/second
fetchRow :: Url -> Int -> Either ClientException String
fetchRow url id' = case getRow id' of
    Left ex -> case ex of
        RowNotFoundException _ -> Left $ NotFoundException url
        DBConnectionException _ -> Left InternalServerError -- todo logger
    Right row -> case formatRow row of
        Left ex2 -> case ex2 of
            NonsenseException _ -> Left InternalServerError
            UnexpectedException -> Left $ NotFoundException (Url "place")
        Right formatted -> Right formatted

main :: IO ()
main = do
    let xs = fetchRow (Url "url") <$> [0..5]

    -- todo MonadError
    -- todo indexed
    mapM_ (\case
        Left x -> putStrLn $ "Error: " <> show x
        Right res' -> putStrLn $ "Found: " <> show res'
        ) xs
    -- todo throwIO?