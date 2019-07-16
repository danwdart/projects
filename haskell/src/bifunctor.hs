import Control.Monad
import Data.Bifunctor

type ESI = Either String Int
type EtoE = ESI -> ESI

myResult1 :: ESI
myResult1 = Left "Oh no, something bad happened."

myResult2 :: ESI
myResult2 = Right 1


fm :: EtoE
fm = first ("Caught error (if there was one): "++)

sm :: EtoE
sm = second (+2388)

bm :: EtoE
bm = bimap ("Was going to add one but it doesn't matter: "++) (+1)


main :: IO ()
main = forM_ [fm, sm, bm] $ \m -> forM_ [myResult1, myResult2] $ \r -> print $ m r