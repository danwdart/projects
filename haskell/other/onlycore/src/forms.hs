{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Form
import Paths_onlycore
import Text.Parsec.Text

main ∷ IO ()
main = do
    file <- getDataFileName "example.form"
    form <- parseFromFile formParser file
    print form
