{-# LANGUAGE OverloadedLists #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main (main) where

import Control.Exception
-- import Data.Char
import Data.List          qualified as L
import Data.List.NonEmpty (NonEmpty)
import Data.List.NonEmpty qualified as LNE

newtype Polynomial = Polynomial {
    getPolynomial :: NonEmpty Int
} deriving stock (Show)

data PolynomialError = EmptyListException | AllZeroException
    deriving stock (Show)

instance Exception PolynomialError

-- >>> pretty <$> fromIntList [1,2,3]
-- Right "1 + 2x + 3x\178"
--
fromIntList ∷ [Int] → Either PolynomialError Polynomial
fromIntList xs
    | null xs = Left EmptyListException
    | all (== 0) xs = Left AllZeroException
    | otherwise = Right . Polynomial . LNE.fromList $ xs

-- >>> pretty <$> (fromNonEmpty . fromList $ [1,2,3,4])
-- Right "1 + 2x + 3x\178 + 4x\179"
--
fromNonEmpty ∷ NonEmpty Int → Either PolynomialError Polynomial
fromNonEmpty xs
    | all (== 0) xs = Left AllZeroException
    | otherwise = Right . Polynomial $ xs

-- >>> putStrLn . L.singleton . powerDigit $ 4
-- ⁴
--
powerDigit ∷ Int → Char
powerDigit = (LNE.fromList "⁰¹²³⁴⁵⁶⁷⁸⁹" LNE.!!)

-- >>> putStrLn . powerOf $ 54
-- ⁵⁴
--
powerOf ∷ Int → String
powerOf = fmap (powerDigit . read @Int . L.singleton) . show

-- >>> import Data.Foldable
-- >>> traverse_ putStrLn $ (\i -> show i <> ": (" <> showPoly i <> ")") <$> [0..4]
-- 0: ()
-- 1: (x)
-- 2: (x²)
-- 3: (x³)
-- 4: (x⁴)
--
showPoly ∷ Int → String
showPoly i
    | i == 0 = ""
    | i == 1 = "𝑥"
    | otherwise = "𝑥" <> powerOf i

-- >>> intercalate " + " $ toList $  fmap (\(i, a) -> show a <> showPoly i) $ LNE.zip (LNE.fromList [0..]) $ getPolynomial $ Polynomial $ fromList [1,2,3,4]
-- "1 + 2x + 3x\178 + 4x\179"
--

-- >>> putStrLn . pretty . Polynomial . fromList $ [1,2,3,4]
-- 1 + 2x + 3x² + 4x³
--
pretty ∷ Polynomial → String
pretty = L.intercalate " + " . LNE.toList . fmap (\(i, a) -> show a <> showPoly i) . LNE.zip (LNE.fromList [0..]) . getPolynomial

-- mul :: Polynomial -> Polynomial -> Polynomial
-- mul (Polynomial (x :| xs)) (Polynomial (y :| ys)) = undefined --

main ∷ IO ()
main = pure ()
