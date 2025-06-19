{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings         #-}
{-# LANGUAGE RecursiveDo               #-}
{-# LANGUAGE Unsafe                    #-}
{-# OPTIONS_GHC -Wno-type-defaults #-}

module Main (main) where

import Reflex.Dom

main ∷ IO ()
main = mainWidgetWithHead (
    do
        el "title" $ text "Cards UI"
        elAttr "meta" ("name" =: "shortcut-icon" <> "content" =: "sample.png") blank
    ) $
    mdo
        el "h1" $ text "Cards UI"
