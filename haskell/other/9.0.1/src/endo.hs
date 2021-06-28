{-# LANGUAGE OverloadedStrings #-}

import           Data.Semigroup
import           Data.Text

excite :: Text -> Text
excite = (<> "!")

multiExcite :: Int -> Text -> Text
multiExcite = flip stimes excite

multiEndoExcite :: Int -> Text -> Text
multiEndoExcite n = appEndo . stimes n $ Endo excite

main :: IO ()
main = do
    print . multiExcite 3 $ "Hi" -- This is "Hi!Hi!Hi!"
    print . multiEndoExcite 3 $ "Hi" -- but this is "Hi!!!"
