{-# OPTIONS_GHC -ddump-splices -Wno-unsafe #-}
{-# LANGUAGE DeriveAnyClass  #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE Unsafe          #-}

{- Provide a dynamic schema. -}

module Main (main) where

-- import Data.Map
import BookStatic
import Data.Yaml.TH
import Language.Haskell.TH

-- Method 1: TH (you use this)

myDataStatic ∷ [Book]
myDataStatic = $$(Code $ Data.Yaml.TH.decodeFile "data/books.yaml")

-- Method 2: Map (only your users use this)

{-
data Entity schemaType = forall a. Entity [(Text, a)] -- what's this meant to be?

bookSchema :: IO (Maybe Schema)
bookSchema = Data.Yaml.decodeFile "data/bookSchema.yaml"

myDataDynamic :: IO (Maybe [Entity bookSchema'])
myDataDynamic = Data.Yaml.decodeFile "data/books.yaml"
-}

main ∷ IO ()
main = do
    print myDataStatic
    -- d <- myDataDynamic
    -- print d
