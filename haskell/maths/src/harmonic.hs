{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wno-type-defaults #-}

-- A004080
import           Data.List.Extra
import           Data.Tuple.Extra

-- both = bimapBoth from Relude.Extra.Bifunctor over tuples

-- *>>

result ∷ [(Int, Int)]
result = nubOrdOn snd . fmap (both floor) $ scanl1 (\(_,b0) (a1, b1) -> (a1, b0 + b1)) [ (x,1/x) | x <- [1..1000000000000000]]

-- Code from site just gets the nth value and to do it, finds its index:

-- a004080 n = fromJust $ findIndex (fromIntegral n <=) $ scanl (+) 0 $ map recip [1..]

main ∷ IO ()
main = print result
