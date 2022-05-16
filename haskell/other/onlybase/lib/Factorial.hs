module Factorial where

import Numeric.Natural

(!) ∷ Natural → Natural
(!) 0 = 0
(!) 1 = 1
(!) x = x * ((x - 1) !)
