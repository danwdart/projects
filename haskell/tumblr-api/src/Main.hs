{-# LANGUAGE OverloadedStrings #-}

import           Configuration.Dotenv
import           Control.Monad                (void)
import           Control.Monad.Trans.Resource
import           Data.ByteString.Char8
import           Data.Functor.Compose
import qualified Network.HTTP.Conduit         as NetConduit
import           System.Environment
import qualified Web.Tumblr                   as Tumblr

main ∷ IO ()
main = do
  [blog, tag, _] <- getCompose $ pack <$> Compose getArgs
  void $ loadFile defaultConfig
  oauthConsumerKey <- pack <$> getEnv "OAUTH_CONSUMER_KEY"
  oauthConsumerSecret <- pack <$> getEnv "OAUTH_CONSUMER_SECRET"
  let oauth = Tumblr.tumblrOAuth oauthConsumerKey oauthConsumerSecret
  -- getTumblrInfo mgr hostname = runResourceT $ runReaderT (Tumblr.tumblrInfo hostname mgr) oauth
  mgr <- NetConduit.newManager NetConduit.tlsManagerSettings
  _ <- runResourceT $ Tumblr.tumblrAuthorize oauth mgr
  posts <- runResourceT $ runReaderT (Tumblr.tumblrPosts blog Nothing Nothing (Just (unpack tag)) (Just 20) (Just 0) Nothing Nothing Nothing mgr) oauth

  print posts


  -- val <- getTumblrInfo mgr "dantst.tumblr.com"
  --print val
  pure ()
