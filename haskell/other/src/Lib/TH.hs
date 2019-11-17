{-# LANGUAGE TemplateHaskell #-}

module Lib.TH (infoToExp, filterOK) where

import Language.Haskell.TH

infoToExp :: Info -> ExpQ
infoToExp (VarI _ k _) = stringE . show $ k
infoToExp _ = error "Unsupported"

filterOK :: String -> String
filterOK = filter (`notElem` '_':['0'..'9'])