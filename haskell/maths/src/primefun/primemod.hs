{-# LANGUAGE UnicodeSyntax #-}
import           Control.Arrow
import           Data.List

mk ∷ Int → [[Int]]
mk k = fmap (\ n -> fmap (\ m -> (n * m) `mod` k) [0 .. n]) [0 .. k - 1]

fn ∷ Int → (Int, [Int])
fn p = (p,
    fmap fst . filter (\ x -> snd x == 1) $ (fmap (head &&& length) . group . sort) (concat $ mk p)
    )

main ∷ IO ()
main = mapM_ (print . fn) [1 .. 10]
