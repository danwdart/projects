{-# LANGUAGE OverloadedStrings #-}

module Main where

import Criterion.Main
import Control.DeepSeq
import Data.Dynamic
import Data.Maybe
import qualified Data.Array as A
import qualified Data.Vector as V
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as B8
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Lazy.Char8 as BL8
import Data.String
import qualified Data.Text as T
import qualified Data.Text.Lazy as TL

elements :: Int
elements = 1000000

str :: IsString s => s
str = "Hello World"

listRepl :: a -> [a]
listRepl = replicate elements

vecRepl :: a -> V.Vector a
vecRepl = V.replicate elements

arrRepl :: a -> A.Array Int Int
arrRepl n = A.listArray (0, elements - 1) [0..elements - 1]

-- either a type name fmap or a disparate list

{-}
main = defaultMain $ fmap (\(evaluatorName, evaluator) ->
    bgroup evaluatorName $
        fmap (\(listTypeName, listCreator) ->
            bgroup listTypeName $
                fmap (\(stringLibraryName, libraryTypes) ->
                    bgroup stringLibraryName $
                        fmap (\(stringTypeName, stringInType) ->
                                bench stringTypeName $ evaluator listCreator (fromJust . fromDynamic $ stringInType)
                            ) libraryTypes
                    ) [
                        (
                            "String",
                            [
                                (
                                    "String", toDyn (fromString str :: String)
                                )
                                ]
                        ),
                        (
                            "Text",
                            [
                                (
                                    "T.Text", toDyn (fromString str :: T.Text)
                                ),
                                (
                                    "TL.Text", toDyn (fromString str :: TL.Text)
                                )
                                ]
                        ),
                        (
                            "ByteString",
                            [
                                (
                                    "B.ByteString", toDyn (fromString str :: B.ByteString)
                                ),
                                (
                                    "B8.ByteString", toDyn (fromString str :: B8.ByteString)
                                ),
                                (
                                    "BL.ByteString", toDyn (fromString str :: BL.ByteString)
                                ),
                                (
                                    "BL8.ByteString", toDyn (fromString str :: BL8.ByteString)
                                )
                            ]
                        )
                    ]
            ) [
                ("String", listRepl),
                ("Vector", vecRepl)
            ]
    ) [
        ("whnf", whnf),
        ("nf", nf)
    ]
-}

main = defaultMain [
    bgroup "nf" [
        bgroup "List" [
            bench "String"              $ nf listRepl (fromString str :: String),
            bgroup "Text" [
                bench "T.Text"              $ nf listRepl (fromString str :: T.Text),
                bench "TL.Text"             $ nf listRepl (fromString str :: TL.Text)
                ],
            bgroup "ByteString" [
                bench "B.ByteString"        $ nf listRepl (fromString str :: B.ByteString),
                bench "B8.ByteString"       $ nf listRepl (fromString str :: B8.ByteString),
                bench "BL.ByteString"       $ nf listRepl (fromString str :: BL.ByteString),
                bench "BL8.ByteString"      $ nf listRepl (fromString str :: BL8.ByteString)
                ]
            ],
        bgroup "Vector" [
            bench "String"         $ nf vecRepl  (fromString str :: String),
            bgroup "Text" [
                bench "T.Text"         $ nf vecRepl  (fromString str :: T.Text),
                bench "TL.Text"        $ nf vecRepl  (fromString str :: TL.Text)
                ],
            bgroup "ByteString" [
                bench "B.ByteString"   $ nf vecRepl  (fromString str :: B.ByteString),
                bench "B8.ByteString"  $ nf vecRepl  (fromString str :: B8.ByteString),
                bench "BL.ByteString"  $ nf vecRepl  (fromString str :: BL.ByteString),
                bench "BL8.ByteString" $ nf vecRepl  (fromString str :: BL8.ByteString)
                ]
            ],
        bgroup "Array" [
            bench "String"         $ nf arrRepl  (fromString str :: String),
            bgroup "Text" [
                bench "T.Text"         $ nf arrRepl  (fromString str :: T.Text),
                bench "TL.Text"        $ nf arrRepl  (fromString str :: TL.Text)
                ],
            bgroup "ByteString" [
                bench "B.ByteString"   $ nf arrRepl  (fromString str :: B.ByteString),
                bench "B8.ByteString"  $ nf arrRepl  (fromString str :: B8.ByteString),
                bench "BL.ByteString"  $ nf arrRepl  (fromString str :: BL.ByteString),
                bench "BL8.ByteString" $ nf arrRepl  (fromString str :: BL8.ByteString)
                ]
            ]
        ],
    bgroup "whnf" [
        bgroup "List" [
            bench "String"              $ whnf listRepl (fromString str :: String),
            bgroup "Text" [
                bench "T.Text"              $ whnf listRepl (fromString str :: T.Text),
                bench "TL.Text"             $ whnf listRepl (fromString str :: TL.Text)
                ],
            bgroup "ByteString" [
                bench "B.ByteString"        $ whnf listRepl (fromString str :: B.ByteString),
                bench "B8.ByteString"       $ whnf listRepl (fromString str :: B8.ByteString),
                bench "BL.ByteString"       $ whnf listRepl (fromString str :: BL.ByteString),
                bench "BL8.ByteString"      $ whnf listRepl (fromString str :: BL8.ByteString)
                ]
            ],
        bgroup "Vector" [
            bench "String"         $ whnf vecRepl  (fromString str :: String),
            bgroup "Text" [
                bench "T.Text"         $ whnf vecRepl  (fromString str :: T.Text),
                bench "TL.Text"        $ whnf vecRepl  (fromString str :: TL.Text)
                ],
            bgroup "ByteString" [
                bench "B.ByteString"   $ whnf vecRepl  (fromString str :: B.ByteString),
                bench "B8.ByteString"  $ whnf vecRepl  (fromString str :: B8.ByteString),
                bench "BL.ByteString"  $ whnf vecRepl  (fromString str :: BL.ByteString),
                bench "BL8.ByteString" $ whnf vecRepl  (fromString str :: BL8.ByteString)
                ]
            ],
        bgroup "Array" [
            bench "String"         $ whnf arrRepl  (fromString str :: String),
            bgroup "Text" [
                bench "T.Text"         $ whnf arrRepl  (fromString str :: T.Text),
                bench "TL.Text"        $ whnf arrRepl  (fromString str :: TL.Text)
                ],
            bgroup "ByteString" [
                bench "B.ByteString"   $ whnf arrRepl  (fromString str :: B.ByteString),
                bench "B8.ByteString"  $ whnf arrRepl  (fromString str :: B8.ByteString),
                bench "BL.ByteString"  $ whnf arrRepl  (fromString str :: BL.ByteString),
                bench "BL8.ByteString" $ whnf arrRepl  (fromString str :: BL8.ByteString)
                ]
            ]
        ]
    ]