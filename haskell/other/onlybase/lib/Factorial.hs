module Factorial where

import Numeric.Natural

-- >>> (4 !)
-- 24
--

(!) ∷ Natural → Natural
(!) 0 = 1
(!) 1 = 1
(!) x = x * ((x - 1) !)
