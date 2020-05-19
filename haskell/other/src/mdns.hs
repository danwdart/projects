{-# LANGUAGE UnicodeSyntax #-}
import           Network.Avahi

main ∷ IO ()
main = browse $ BrowseQuery PROTO_UNSPEC "_smb._tcp" "" print
