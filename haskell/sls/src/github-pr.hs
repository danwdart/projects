{-# LANGUAGE OverloadedStrings #-}

import AWSLambda
import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as BSL
import Data.Text

main :: IO ()
main = lambdaMain handler

handler :: Value -> IO String
handler evt = do
    print evt
    return $ BSL.unpack $ encode ("a" .= ("b" :: Text) :: Object)