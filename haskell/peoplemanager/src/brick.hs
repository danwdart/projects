{-# LANGUAGE OverloadedStrings #-}

module Main where

import Brick
import Brick.Widgets.List
import qualified Data.Vector as V

main :: IO ()
main = simpleMain $
    renderList
        (\bC e -> str e)
        True
        (
            list
                "aaa"
                (
                    V.fromList [
                        "First Item",
                        "Second Item",
                        "Third Item"
                        ]
                    )
                    2
            )