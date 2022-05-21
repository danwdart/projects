{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Safe #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module TinyLang where

import Data.ByteString.Char8
import Data.Map

newtype Fd = Fd Int

data Queue = FIFO | FILO

data DataType = Char8
data Datum = ByteString

newtype Param = Param DataType
newtype Ret = Ret DataType

data Instruction =
    Datum Char |
    FDIO Fd |
    Iterate Int Instruction |
    Push Queue |
    Pull Queue |
    Function [Param] [Instruction] Ret

hWInst :: [Instruction]
hWInst = Datum <$> "Hello World\n" -- <> Iterate 12 (FDIO 1)

instructions :: Map ByteString Instruction
instructions = []

hW :: ByteString
hW = ""