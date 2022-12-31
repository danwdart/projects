{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-safe -Wno-unsafe #-}

import           Network.Avahi

main ∷ IO ()
main = browse $ BrowseQuery PROTO_UNSPEC "_smb._tcp" "" print
