{-# LANGUAGE Safe #-}
module Secret where

-- Stolen from https://bartoszmilewski.com/2022/04/05/teaching-optics-through-conspiracy-theories/

data Secret guess = forall secret. Secret secret (secret → guess → Bool)

checkSecret ∷ Secret a → a → Bool
checkSecret (Secret secret check) = check secret

mySecret ∷ Secret String
mySecret = Secret "dontreadme" (==)

myHashedSecret ∷ Secret Int
myHashedSecret = Secret 12 (\secret guess -> guess * 12 == secret)
