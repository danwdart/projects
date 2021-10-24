{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-unused-matches #-}

import Data.Bits
import Data.Word
import Prelude as P
import Data.ByteString as B
import Data.ByteString.Internal as B

main :: IO ()
main = pure ()

h0, h1, h2, h3, h4 :: Int
h0 = 0x67452301
h1 = 0xEFCDAB89
h2 = 0x98BADCFE
h3 = 0x10325476
h4 = 0xC3D2E1F0

str :: ByteString
str = "The quick brown fox jumps over the lazy dog"

step1 :: ByteString
step1 = str <> B.packBytes [0x80] -- assume byte length

step2 :: ByteString
step2 = step1 <> B.packBytes (P.replicate (56 - lstr) 0)

word64ToWord8sBE :: Word64 -> [Word8]
word64ToWord8sBE x = [
    fromIntegral (shiftR x 56),
    fromIntegral (shiftR x 48),
    fromIntegral (shiftR x 40),
    fromIntegral (shiftR x 32),
    fromIntegral (shiftR x 16),
    fromIntegral (shiftR x 8),
    fromIntegral x
    ]

word64ToWord8sLE :: Word64 -> [Word8]
word64ToWord8sLE x = [
    fromIntegral x,
    fromIntegral (shiftR x 8),
    fromIntegral (shiftR x 16),
    fromIntegral (shiftR x 24),
    fromIntegral (shiftR x 32),
    fromIntegral (shiftR x 40),
    fromIntegral (shiftR x 48),
    fromIntegral (shiftR x 56)
    ]

word8sToWord32BE :: [Word8] -> Word32
word8sToWord32BE [a,b,c,d] = ((((fromIntegral a * 256) + fromIntegral b) * 256) + fromIntegral c) * 256 + fromIntegral d
word8sToWord32BE _ = error "Need 4 Word8s"

word8sToWord32LE :: [Word8] -> Word32
-- @TODO reverse call
word8sToWord32LE [a,b,c,d] = ((((fromIntegral d * 256) + fromIntegral c) * 256) + fromIntegral b) * 256 + fromIntegral a
word8sToWord32LE _ = error "Need 4 Word8s"

chunksOf :: Int -> [e] -> [[e]]
chunksOf i ls = P.map (P.take i) (build (splitter ls)) where
    splitter :: [e] -> ([e] -> a -> a) -> a -> a
    splitter [] _ n = n
    splitter l c n  = l `c` splitter (P.drop i l) c n
    build :: ((a -> [a] -> [a]) -> [a] -> [a]) -> [a]
    build g = g (:) []

step3 :: ByteString
step3 = step2 <> B.packBytes (word64ToWord8sBE (fromIntegral ml))

step3AsBin :: [Word8]
step3AsBin = B.unpack step3

step4 :: [Word32]
step4 = P.map word8sToWord32BE (chunksOf 4 step3AsBin)

step5 :: [Word32]
step5 = extend step4 where
    extend :: [Word32] -> [Word32]
    extend xs = xs <> [
        ((xs !! (P.length xs - 3)) `xor`
        (xs !! (P.length xs - 8)) `xor`
        (xs !! (P.length xs - 14)) `xor`
        (xs !! (P.length xs - 16)))
        `rotateL` 1
        ]

lstr :: Int
lstr = B.length str

-- 64 bytes

ml :: Int
ml = 8 * B.length str

expectedOutput :: ByteString
expectedOutput = "2fd4e1c67a2d28fced849ee1bb76e7391b93eb12"