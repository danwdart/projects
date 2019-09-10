import Network.Avahi

main :: IO ()
main = browse $ BrowseQuery PROTO_UNSPEC "" "local" print