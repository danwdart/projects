{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE GADTs             #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import Data.DisparateList

data G a where
    GBool :: G Bool
    GInt :: G Int

f ∷ G a → a
f GBool = False
f GInt  = 0

data Arrow a b where
    Fn :: (a → b) -> Arrow a b
    Comp :: Arrow b c -> Arrow a b -> Arrow a c

eval ∷ Arrow a b → a → b
eval (Fn f') x     = f' x
eval (Comp f' g) x = eval f' (eval g x)

num ∷ Arrow a b → Int
num (Fn _)      = 0
num (Comp f' g) = 1 + num f' + num g

hmm ∷ Enum a ⇒ Arrow a a
hmm = Comp (Comp (Fn succ) (Fn succ)) (Comp (Fn succ) (Fn succ))

ids ∷ Arrow a a
ids = Comp (Comp (Fn id) (Fn id)) (Comp (Fn id) (Fn id))
-- deriving instance (Show a, Show (L t)) => Show (L (a ': t))

main ∷ IO ()
main = do
    print $ f GBool
    print $ f GInt
    print ((2::Int) :> "a" :> Nil)
    print Nil
    print $ eval hmm (1::Int)
    print $ num ids
