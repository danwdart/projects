{-# LANGUAGE OverloadedStrings #-}

module Main where

import AWSLambda
import Data.Function
import Data.Functor
import Faker
import Faker.TvShow.StarTrek
import qualified Data.Text as T
-- import Data.Text (Text)
import qualified Data.Aeson as A

gimme :: Fake a -> IO a
gimme = generateWithSettings (setLocale "en" $ setNonDeterministic defaultFakerSettings)

main :: IO ()
main = lambdaMain handler

handler :: A.Value -> IO String
handler evt = do
  str <- character <&> (`T.append` " is awesome") & gimme <&> T.unpack
  putStrLn str
  print evt
  return str