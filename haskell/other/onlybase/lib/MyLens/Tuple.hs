module MyLens.Tuple where

import MyLens

_1 ∷ Lens (a, b) (c, b) a c
_1 = lens fst (\(_, b) c -> (c, b))

_2 ∷ Lens (a, b) (a, c) b c
_2 = lens snd (\(a, _) c -> (a, c))
