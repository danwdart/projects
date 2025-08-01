{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE GHC2024               #-}
{-# LANGUAGE RequiredTypeArguments #-}
{-# LANGUAGE UnicodeSyntax         #-}

module Main where

import Data.Bits
import Data.Kind
import Data.Proxy
import GHC.TypeNats (KnownNat (..), Nat, natVal)

type Mod :: Nat → Type
newtype Mod n = Mod {
    getMod :: Integer
} deriving stock (Eq, Show)
-- TODO bounded, enum

instance KnownNat n ⇒ Num (Mod n) where
    Mod a + Mod b = Mod ((a + b + n) `mod` n) where -- not integer?
        n = fromIntegral $ natVal (Proxy :: Proxy n)
    Mod a * Mod b = Mod ((a * b + n) `mod` n) where -- not integer?
        n = fromIntegral $ natVal (Proxy :: Proxy n)
    abs (Mod a) = Mod (abs a + n `mod` n) where -- not integer?
        n = fromIntegral $ natVal (Proxy :: Proxy n)
    signum (Mod a) = Mod ((signum a + n) `mod` n) where -- not integer?
        n = fromIntegral $ natVal (Proxy :: Proxy n)
    negate (Mod a) = Mod ((negate a + n) `mod` n) where -- not integer?
        n = fromIntegral $ natVal (Proxy :: Proxy n)
    fromInteger a = Mod ((a + n) `mod` n) where -- not integer?
        n = fromIntegral $ natVal (Proxy :: Proxy n)

instance KnownNat n => Enum (Mod n) where
    toEnum = fromInteger . toInteger
    fromEnum = fromInteger . getMod

instance KnownNat n => Bounded (Mod n) where
    minBound = 0
    maxBound = (-1)

instance KnownNat n => Bits (Mod n) where
    Mod a .&. Mod b = Mod ((a .&. b) `mod` n) where -- not integer?
        n = fromIntegral $ natVal (Proxy :: Proxy n)
    Mod a .|. Mod b = Mod ((a .|. b) `mod` n) where -- not integer?
        n = fromIntegral $ natVal (Proxy :: Proxy n)
    (Mod a) `xor` (Mod b) = Mod ((a `xor` b) `mod` n) where -- not integer?
        n = fromIntegral $ natVal (Proxy :: Proxy n)
    complement (Mod a) = Mod ((complement a) `mod` n) where -- not integer?
        n = fromIntegral $ natVal (Proxy :: Proxy n)
    shift (Mod a) leftBy = Mod ((shift a leftBy) `mod` n) where -- not integer?
        n = fromIntegral $ natVal (Proxy :: Proxy n)
    rotate (Mod a) leftBy = Mod ((rotate a leftBy) `mod` n) where -- not integer?
        n = fromIntegral $ natVal (Proxy :: Proxy n)
    bitSize (Mod a) = bitSize a
    bitSizeMaybe (Mod a) = bitSizeMaybe a
    isSigned (Mod a) = isSigned a
    testBit (Mod a) = testBit a
    bit loc = Mod ((bit loc) `mod` n) where -- not integer?
        n = fromIntegral $ natVal (Proxy :: Proxy n)
    popCount (Mod a) = popCount a

-- >>> 10 `xor` 2 :: Mod 3
-- Mod {getMod = 0}
--

-- trinary stuff?


coprime :: Int -> Int -> Bool
coprime x y = gcd x y == 1

-- >>> coprimeLessThan 9
-- [1,2,4,5,7,8]
--
coprimeLessThan :: Int -> [Int]
coprimeLessThan n = filter (coprime n) [1..n]

-- >>> totient 10
-- 4
--
totient :: Int -> Int
totient = length . coprimeLessThan

allValues :: (Enum a, Bounded a) => [a]
allValues = [minBound..maxBound]

allValsFrom :: (Enum a, Bounded a) => a -> [a]
allValsFrom n = [n..maxBound]

-- >>> :set -XDataKinds
-- >>> Mod 2 + Mod 5 :: Mod 4
-- Mod {getMod = 3}
--
-- >>> Mod 2 * Mod 5 :: Mod 4
-- Mod {getMod = 2}
--
-- >>> abs (Mod (-2)) :: Mod 3
-- Mod {getMod = 2}
--
-- >>> signum (Mod (-3)) :: Mod 3
-- Mod {getMod = 2}
--
-- >>> negate (Mod 7) :: Mod 9
-- Mod {getMod = 2}
--
-- >>> fromInteger 44 :: Mod 21
-- Mod {getMod = 2}
--

-- >>> [minBound..maxBound] :: [Mod 9]
-- [Mod {getMod = 0},Mod {getMod = 1},Mod {getMod = 2},Mod {getMod = 3},Mod {getMod = 4},Mod {getMod = 5},Mod {getMod = 6},Mod {getMod = 7},Mod {getMod = 8}]
--

-- >>> fullTable 5 1 (*)
-- [[Mod {getMod = 1},Mod {getMod = 2},Mod {getMod = 3},Mod {getMod = 4}],[Mod {getMod = 2},Mod {getMod = 4},Mod {getMod = 1},Mod {getMod = 3}],[Mod {getMod = 3},Mod {getMod = 1},Mod {getMod = 4},Mod {getMod = 2}],[Mod {getMod = 4},Mod {getMod = 3},Mod {getMod = 2},Mod {getMod = 1}]]
--
fullTable ∷ forall n -> KnownNat n => Mod n -> (Mod n -> Mod n -> Mod n) -> [[Mod n]]
fullTable _ minNum f = fmap (\x -> f x <$> allValsFrom minNum) (allValsFrom minNum)

binaryOneBitTruthTable :: (Mod 2 -> Mod 2 -> Mod 2) -> [[Mod 2]]
binaryOneBitTruthTable = fullTable 2 0

-- >>> coprimeTable 4 (*)
-- [[Mod {getMod = 1},Mod {getMod = 3}],[Mod {getMod = 3},Mod {getMod = 1}]]
--
coprimeTable ∷ forall n -> KnownNat n => (Mod n -> Mod n -> Mod n) -> [[Mod n]]
coprimeTable n f = fmap (\x -> fmap (\y -> f x y) nums) nums where
    nums :: [Mod n]
    nums = Mod . fromIntegral <$> coprimeLessThan (fromIntegral $ natVal (Proxy :: Proxy n))

-- minTableStruct :: [[Mod n]] -> [[Mod n]]
-- minTableStruct = _

-- >>> displayTable $ fullTable 5 1 (*)
-- "1 2 3 4\n2 4 1 3\n3 1 4 2\n4 3 2 1\n"
--
-- >>> displayTable $ coprimeTable 6 (*)
-- "1 5\n5 1\n"

-- >>> displayTable $ binaryOneBitTruthTable xor
-- "0 1\n1 0\n"
--

-- >>> displayTable $ binaryOneBitTruthTable (+)
-- "0 1\n1 0\n"

-- >>> displayTable $ binaryOneBitTruthTable(*)
-- "0 0\n0 1\n"
--

-- >>> displayTable $ fullTable 2 0 (.&.)
-- "0 0\n0 1\n"
--

-- >>> displayTable $ fullTable 2 0 (.&.)
-- <interactive>:630:31-35: error: [GHC-39999]
--     • No instance for ‘Bits (Mod 2)’ arising from a use of ‘.&.’
--     • In the third argument of ‘fullTable’, namely ‘(.&.)’
--       In the second argument of ‘($)’, namely ‘fullTable 2 0 (.&.)’
--       In the expression: displayTable $ fullTable 2 0 (.&.)
-- <BLANKLINE>
--
displayTable :: [[Mod n]] -> String
displayTable = unlines . fmap (unwords . fmap (show . getMod))


main ∷ IO ()
main = putStrLn . displayTable $ coprimeTable 12 (*)
