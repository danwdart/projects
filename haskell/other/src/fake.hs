{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UnicodeSyntax     #-}

import           Data.Function
import           Data.Functor
import qualified Data.Text             as T
import           Faker
import           Faker.TvShow.StarTrek
-- import Data.Text (Text)

gimme ∷ Fake a → IO a
gimme = generateWithSettings (setNonDeterministic defaultFakerSettings)

main ∷ IO ()
main = (character <&> (`T.append` " is awesome") & gimme) >>= putStrLn . T.unpack
