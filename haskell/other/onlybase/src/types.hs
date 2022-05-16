import           Auth

main ∷ IO ()
main = print $ authenticate "bob@bob.com" "password"
