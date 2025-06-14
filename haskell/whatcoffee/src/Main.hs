{-# LANGUAGE DerivingVia    #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
{-# OPTIONS_GHC -Wno-unused-imports -Wno-x-partial #-}

module Main (main) where

import Data.Aeson             qualified as A
import Data.Aeson.Types
import Data.ByteString.Base64 qualified as B64
import Data.ByteString.Char8  qualified as BS
import Data.ByteString.Lazy   qualified as BSL
import Data.Either
import Data.Foldable
import Data.Maybe
import Data.Text              (Text)
import Data.Text              qualified as T
import Data.Text.Encoding     qualified as TE
import Data.Text.IO           qualified as TIO
import Data.Time
import Data.UUID.Types        (UUID)
import GHC.Generics
import GHC.Stack              (HasCallStack)
import System.Environment
import Text.Printf            (printf)
-- import Web.JWT qualified as JWT

newtype Id = Id Integer deriving stock (Eq, Show)

instance A.FromJSON Id where
    parseJSON (A.String a) = pure $ Id (read (T.unpack a))
    -- @TODO parse with better encoder?
    parseJSON (A.Number a) = pure $ Id (round a)
    parseJSON invalid = prependFailure "parsing Id failed, " (typeMismatch "String | Number" invalid)

data Coffee = Coffee {
    machineNo :: Text,
    amount    :: Int,
    keyId     :: Id,
    guid      :: UUID,
    drinkId   :: Text,
    currency  :: Text,
    timestamp :: Text, -- TODO decode timestamp
    siteId    :: Id
}
    deriving stock (Show, Eq, Generic)
    deriving (A.FromJSON) via Generically Coffee

prettyPrintMachine ∷ Text → Text
prettyPrintMachine "11317961" = "Co-Op Shepton Mallet"
prettyPrintMachine "21105919" = "Tesco Shepton Mallet"
prettyPrintMachine a          = a

prettyPrintSite ∷ Id → Text
prettyPrintSite (Id 60502008)  = "Co-Op Shepton Mallet"
prettyPrintSite (Id 600022459) = "Tesco Shepton Mallet"
prettyPrintSite (Id a)         = T.show a

prettyPrintKey ∷ Id → Text
prettyPrintKey (Id 119301018123828) = "Co-Op Shepton Mallet"
prettyPrintKey (Id 114141220125232) = "Tesco Shepton Mallet"
prettyPrintKey (Id a)               = T.show a

-- @TODO parse properly
prettyPrintDrink ∷ Text → Text
prettyPrintDrink "LATT-LC1-H-1CAR-C-SC01" = "Caramel Latte SC"
prettyPrintDrink "LATT-LC1-H-1CAR-C-BF01" = "Caramel Latte BF"
prettyPrintDrink "LATT-LC1-H-1VAN-C-SC01" = "Vanilla Latte"
prettyPrintDrink "LATT-LC1-H-1VEL-C-SC01" = "Velvet Latte?"
prettyPrintDrink "CAPP-LC1-H-0000-C-SC01" = "Cappucino"
prettyPrintDrink "CAPP-LC1-H-1CAR-C-SC01" = "Caramel Cappucino"
prettyPrintDrink "AMEB-LC1-0-0000-C-SC01" = "Americano?"
prettyPrintDrink a                        = a

prettyPrintCoffee ∷ Coffee → Text
prettyPrintCoffee Coffee {..} =
    "Machine = " <> prettyPrintMachine machineNo <>
    ", price = " <> currency <> " " <> T.pack (printf "%.2g" ((fromIntegral amount :: Double) / 100) :: String) <>
    ", key = from " <> prettyPrintKey keyId <>
    ", GUID = " <> T.show guid <>
    ", drink = " <> prettyPrintDrink drinkId <>
    ", time = " <> timestamp <>
    ", site = " <> prettyPrintSite siteId

main ∷ HasCallStack ⇒ IO ()
main = do
    files <- getArgs
    toRead <- TE.decodeUtf8Lenient <$> if null files || "-" == head files
        then
            BS.getContents
        else
            BS.readFile $ head files
    for_ (T.lines toRead) $ \jwt -> do
        let jwtSegments = T.split (== '.') jwt
        -- let jwtToDecode = T.intercalate "." $ tail jwtSegments
        -- print jwtToDecode
        let jsonBase64 = (case drop 2 jwtSegments of
               x : _ -> x
               []    -> error "Not at least 3 segments - todo print error properly")
        let eitherJson = B64.decode (TE.encodeUtf8 jsonBase64)
        case eitherJson of
            Right json -> do
                let decodedCoffee = A.eitherDecode (BSL.fromStrict json) :: Either String Coffee
                -- print decodedCoffee
                case decodedCoffee of
                    Left _  -> pure ()
                    Right t -> TIO.putStrLn . prettyPrintCoffee $ t
                -- let decoded = JWT.decode jwtToDecode
                -- print decoded
            _ -> TIO.putStrLn "Error decoding JSON"
