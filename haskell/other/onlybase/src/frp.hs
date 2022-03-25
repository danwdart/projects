{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

type Event t a = [(t, a)]
type Behaviour t a = t → a

main ∷ IO ()
main = pure ()
