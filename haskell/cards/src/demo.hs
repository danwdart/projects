{-# LANGUAGE UnicodeSyntax #-}
import           Ordering
import           Suit.Bounded.Standard
import           Symbol
import           Value.Bounded.Standard

main ∷ IO ()
main = do
    mapM_ putStr $ fmap (symbol . (\(BySuitThenValue c) -> c))  ( [minBound..maxBound] :: [BySuitThenValue Value Suit])
    putStrLn ""
