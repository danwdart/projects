{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UnicodeSyntax     #-}

import           Control.Monad.Except
-- import Control.Monad.IO.Class (MonadIO, liftIO)
-- import Control.Retry
-- import Data.Aeson
import           Data.Text
import           Network.HTTP.Req

-- Don't error on 404. We just wanna check it.
myHttpConfig ∷ HttpConfig
myHttpConfig = defaultHttpConfig {
    httpConfigCheckResponse = \_ _ _ -> Nothing
}

isUsernameValid ∷ Text → Req Bool
isUsernameValid username = do
    r <- req GET (https "twitter.com" /: username) NoReqBody bsResponse mempty
    pure $ 200 == responseStatusCode r

doesUserExist ∷ Text → IO Bool
doesUserExist = runReq myHttpConfig . isUsernameValid

prettyPrintDoesUserExist ∷ Text → IO Text
prettyPrintDoesUserExist username = do
    userExists <- doesUserExist username
    pure $ username `append` (if userExists then " exists." else " does not exist.")


thePopesUsername ∷ Text
thePopesUsername = "pontifex"

usernames ∷ [Text]
usernames = [thePopesUsername, "bobbybobbobsonsthethird"]


main ∷ IO ()
main = mapM_ (prettyPrintDoesUserExist >=> putStrLn . unpack) usernames
