{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import PersonParser

desc ∷ String
desc = "Dan, 29"

me ∷ Person
me = read desc

me2 ∷ Person2
me2 = read desc

main ∷ IO ()
main = do
    print me
    print me2
