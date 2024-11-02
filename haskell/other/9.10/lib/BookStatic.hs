{-# OPTIONS_GHC -ddump-splices -Wno-unsafe #-}
{-# LANGUAGE DeriveAnyClass  #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE Unsafe          #-}

module BookStatic where

{- Provide a dynamic schema. -}

-- import Data.Map
import Data.Yaml.TH
import Schema

Data.Yaml.TH.decodeFile "data/bookSchema.yaml" >>= expToDecsQ
