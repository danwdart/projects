{-# OPTIONS_GHC -Wno-type-defaults #-}

-- A004080
import           Data.List.Extra
import           Data.Tuple.Extra

-- both = bimapBoth from Relude.Extra.Bifunctor over tuples

-- *>>

-- A004080 		Least k such that H(k) >= n, where H(k) is the harmonic number Sum_{i=1..k} 1/i.

-- e.g. 1, 4, 11, 31, 83, 227, 616, 1674
-- meaning: H(1) is just over 1, H(4) is just over 2, H(11) is just over 3, H(31) is just over 4, etc.
result ∷ [(Int, Int)]
result = nubOrdOn snd . fmap (both floor) $ scanl1 (\(_,b0) (a1, b1) -> (a1, b0 + b1)) [ (x,1/x) | x <- [1..1000000000000000]]

-- Code from site just gets the nth value and to do it, finds its index:

-- a004080 n = fromJust $ findIndex (fromIntegral n <=) $ scanl (+) 0 $ map recip [1..]

main ∷ IO ()
main = print result
