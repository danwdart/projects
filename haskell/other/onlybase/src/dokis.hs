{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-} -- ???

data Dokis = Yuri deriving stock (Show)

myLove ∷ Maybe Dokis
myLove = pure Yuri

main ∷ IO ()
main = print myLove
