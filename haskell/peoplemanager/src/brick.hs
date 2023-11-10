{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Brick
import Brick.Widgets.List
import Data.Vector        qualified as V

main ∷ IO ()
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
