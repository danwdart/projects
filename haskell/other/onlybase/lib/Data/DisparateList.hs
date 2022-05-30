{-# LANGUAGE DataKinds, GADTs #-}

module Data.DisparateList where

data DisparateList ts where
    Nil :: DisparateList []
    -- ???