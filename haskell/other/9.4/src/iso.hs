import Data.Isomorphism

staticIso ∷ Iso (,) Int String
staticIso = Iso (1,"b") ("b",1)

main ∷ IO ()
main = do
    print . embed $ staticIso
    print . project $ staticIso
