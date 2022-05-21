{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import           Control.Monad.Cont
import           Data.Function

c ∷ a → Cont b a
c = cont . (&)

d ∷ (String → a) → Int → a
d = flip (.) show

printf ∷ Cont a (String → IO ())
printf = cont ($ putStrLn)

(...) ∷ (b → c) → (a1 → a2 → b) → a1 → a2 → c
(...) = (.) . (.)
infixr 9 ...

(>...>) ∷ (a1 → a2 → b) → (b → c) → a1 → a2 → c
(>...>) = flip (...)
infixr 9 >...>

(.---.) ∷ (b → c) → (a4 → a5 → a6 → a7 → b) → a4 → a5 → a6 → a7 → c
(.---.) = (...) . (...)
infixr 9 .---.

(>---) ∷ (a4 → a5 → a6 → a7 → b) → (b → c) → a4 → a5 → a6 → a7 → c
(>---) = flip (.---.)
infixr 9 >---

-- Black magic combinator
combineCont ∷ (d → e → f) → ((d → a) → b) → ((e → c) → a) → (f → c) → b
combineCont k f1 f2 a = f1 $ f2 . a ... k

(%) ∷ ((String → a) → b) → ((String → c) → a) → (String → c) → b
(%) = combineCont (++)

main ∷ IO ()
main = do
    runCont (c "foo") print
    runCont printf (d % ($)) 10 "hi"
    runCont printf (($) % ($) % ($)) "my" "name" "bob"
