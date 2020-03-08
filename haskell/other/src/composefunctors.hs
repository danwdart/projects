import Data.Functor.Compose
import Data.Functor.Const
import Data.Functor.Contravariant

dat2 :: Maybe [Int]
dat2 = Just [1,2,3]

dat3 :: Maybe [(Int, Int)]
dat3 = Just [(0, 1),(1, 2),(2, 3)]

main :: IO ()
main = do
    putStrLn "Double functor"
    print $ fmap (+1) <$> dat2
    print $ getCompose $ (+1) <$> Compose dat2
    putStrLn "Triple functor"
    print $ fmap (fmap (+1)) <$> dat3
    print $ getCompose $ fmap (+1) <$> Compose dat3
    putStrLn "Const"
    print $ getConst $ (+ (1 :: Int)) <$> Const (1 :: Int)
    putStrLn "Contra"
    -- map?
    print $ (getComparison $ Comparison compare) 1 1
    -- Equivalence
    print $ (getEquivalence $ Equivalence (==)) 1 1
    -- Op
    print $ getOp (Op show) 1
    print $ (getPredicate $ contramap (+(1 :: Int)) $ Predicate (==2)) 1