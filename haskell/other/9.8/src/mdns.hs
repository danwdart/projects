{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-safe -Wno-unsafe #-}

module Main (main) where

import Network.Avahi

main ∷ IO ()
main = browse $ BrowseQuery PROTO_UNSPEC "_smb._tcp" "" print
