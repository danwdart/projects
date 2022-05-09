{-# LANGUAGE Unsafe #-} -- Of course Yuri is unsafe!
{-# OPTIONS_GHC -Wno-unsafe #-} -- ???

data Dokis = Yuri deriving (Show)

myLove ∷ Maybe Dokis
myLove = pure Yuri

main ∷ IO ()
main = print myLove
