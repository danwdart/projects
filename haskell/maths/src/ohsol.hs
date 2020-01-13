-- https://en.wikipedia.org/wiki/One-handed_solitaire
import Control.Monad.Random.Class
import Data.Function
import Data.Functor
import System.Random.Shuffle

main :: IO ()
main = return ()

type Value = Int
type Suit = Int
type Card = (Value, Suit)
type Deck = [Card]

sameSuit :: Card -> Card -> Bool
sameSuit = on (==) snd

sameValue :: Card -> Card -> Bool
sameValue = on (==) fst

pack :: Deck
pack = flip (,) <$> [1..4] <*> [1..13]

shuffledPack :: MonadRandom m => m Deck
shuffledPack = shuffleM pack

hand :: MonadRandom m => m Deck
hand = take 4 <$> shuffledPack