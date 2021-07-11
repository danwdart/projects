module Lib.TH where

import           Language.Haskell.TH

evilAlien :: Q String
evilAlien = runIO $ readFile "th.hs"
