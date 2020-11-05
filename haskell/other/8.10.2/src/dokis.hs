{-# LANGUAGE UnicodeSyntax #-}
data Dokis = Yuri deriving (Show)

myLove ∷ Maybe Dokis
myLove = pure Yuri

main ∷ IO ()
main = print myLove
