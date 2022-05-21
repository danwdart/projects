{-# LANGUAGE OverloadedStrings         #-}

import Form
import Text.Parsec.Text

main ∷ IO ()
main = do
    form <- parseFromFile formParser "data/example.form"
    print form
