{-# LANGUAGE Strict #-}

module Main (main) where

import Control.Applicative
import Data.Functor.Compose
import Data.Functor.Contravariant
import DoubleCompose

dat2 ∷ Maybe [Int]
dat2 = Just [1,2,3]

dat3 ∷ Maybe [(Int, Int)]
dat3 = Just [(0, 1),(1, 2),(2, 3)]

i ∷ Int
i = 1


main ∷ IO ()
main = do
    putStrLn "Double functor"
    print $ fmap (+ 1) <$> dat2
    print . getCompose $ ((+ 1) <$> Compose dat2)
    putStrLn "Triple functor"
    print $ fmap (fmap (+ 1)) <$> dat3
    print . getCompose $ (fmap (+ 1) <$> Compose dat3)
    putStrLn "Triple functor without an extra fmap"
    print . getCompose $ getCompose ((+ 1) <$> Compose (Compose dat3))
    print . getCompose $ getCompose (fmap (+ 1) . Compose $ Compose dat3)
    putStrLn "Double compose functions"
    print . getCompose2 $ ((+ 1) <$> compose2 dat3)
    putStrLn "Double compose newtype"
    print . getComposeTwo $ ((+ 1) <$> ComposeTwo dat3)
    putStrLn "Const"
    print . getConst $ ((+ i) <$> Const i)
    putStrLn "Contra"
    -- map?
    print $ (getComparison $ Comparison compare) i i
    -- Equivalence
    print $ (getEquivalence $ Equivalence (==)) i i
    -- Op
    print $ getOp (Op show) i
    print $ (getPredicate . contramap (+ i) $ Predicate (== 2)) i
