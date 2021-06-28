{-# LANGUAGE TemplateHaskell #-}

import           Language.Haskell.TH
import           Lib.TH

main :: IO ()
main = print $$(evilAlien)
