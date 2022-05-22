{-
function saa(n) {
    var ns = Math.pow(n,2),
        sn = String(ns),
        l = sn.length,
        fb = Number(sn.substring(0,l/2)),
        lb = Number(sn.substring(l/2,l));
        pure n == fb + lb;
}
for (var i = 0; i < 10000000; i++) {
    if (saa(i)) console.log(i);
}
-}

-- import Data.List

-- splitIntoPieces n l =

{-
saa :: (Num n) => n -> Bool
saa n = n == sum piecesNums where
    squared = n ** 2
    stringSquared = show ns
    piecesStrings = splitIntoPieces 2 stringSquared
    piecesNums = map read piecesStrings :: [Int]

main :: IO ()
main = print $ filter saa [1..10000000]
-}

main ∷ IO ()
main = pure ()
