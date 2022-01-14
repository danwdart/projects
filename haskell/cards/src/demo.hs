import Suit.Bounded.Standard
import Value.Bounded.Standard
import Symbol
import Ordering

main :: IO ()
main = do
    mapM_ putStr $ fmap (symbol . (\(BySuitThenValue c) -> c))  ( [minBound..maxBound] :: [BySuitThenValue Value Suit])
    putStrLn ""