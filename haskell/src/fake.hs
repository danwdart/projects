{-# LANGUAGE OverloadedStrings #-}

import Data.Function
import Data.Functor
import Faker
import Faker.TvShow.StarTrek
import qualified Data.Text as T
import Data.Text (Text)

gimme :: Fake a -> IO a
gimme = generateWithSettings (setNonDeterministic defaultFakerSettings)

main :: IO ()
main = character <&> (`T.append` " is awesome") & gimme <&> T.unpack >>= putStrLn