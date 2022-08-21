-- https://en.wikipedia.org/wiki/Playing_cards_in_Unicode

{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -Wno-orphans -Wno-unused-top-binds -Wwarn #-}

import           Card
import           Control.Monad
import qualified Control.Monad.HT           as HT (nest)
import           Control.Monad.Random.Class
import           Data.Bifoldable
import           Data.Bifunctor
import qualified Data.Map                   as M
import qualified Data.Set                   as S
import           Deck
import           Enum
import           Ordering
import           System.Random.Shuffle

(...) ∷ (b → c) → (a1 → a2 → b) → a1 → a2 → c
(...) = (.) . (.)

-- https://wiki.haskell.org/Random_shuffle


-- randomElem :: RandomGen g => [a] -> g -> (a, g)
-- randomElem elems g = elems !! randomR (0, length elems

main ∷ IO ()
main = do
    putStrLn "Average matches in one round (even-ing out the two lines)"
    avgDist 2000 >>= print . meanDist
    putStrLn "Average non-matches after finishing rounds"
    magicDist 2000 >>= print . meanDist

adj ∷ (Enum a) ⇒ a → a → Bool
adj a b = 1 == abs (fromEnum a - fromEnum b)

eqOrAdj ∷ CardStd → CardStd → Bool
eqOrAdj (Card value1 suit1) (Card value2 suit2) = value1 == value2 || (suit1 == suit2 && adj value1 value2)

-- filter out?

adjPairs ∷ DeckStd → [(CardStd, CardStd)]
adjPairs (Deck d) = filter (uncurry eqOrAdj) (listToPairs d)

pack52 ∷ DeckStd
pack52 = Deck $ getBySuitThenValue <$> enumerate

pack ∷ DeckStd
pack = pack52

again ∷ Semigroup c ⇒ Int → c → c
again = foldl1 (<>) ... replicate

fourpacks ∷ DeckStd
fourpacks = Deck $ again 4 (getDeck pack52)

pickRandomCards ∷ MonadRandom m ⇒ Int → DeckStd → m (DeckStd, DeckStd)
pickRandomCards n p = bimap Deck Deck . splitAt n <$> shuffleM (getDeck p)

pokerHand ∷ MonadRandom m ⇒ DeckStd → m (DeckStd, DeckStd)
pokerHand = pickRandomCards 5

adjCards ∷ DeckStd → DeckStd
adjCards (Deck c) = Deck . fmap getBySuitThenValue. pairsToList . fmap (bimap BySuitThenValue BySuitThenValue) . filter (uncurry eqOrAdj) $ listToPairs c

extractAdj ∷ MonadRandom m ⇒ DeckStd → m DeckStd
extractAdj p = do
    p' <- Deck <$> shuffleM (getDeck p)
    pure . Deck $ filterOutList (getDeck (adjCards p')) (getDeck p')

magicNumbers ∷ MonadRandom m ⇒ m Int
magicNumbers = length . getDeck <$> HT.nest 30 extractAdj pack

magicDist ∷ MonadRandom m ⇒ Int → m (M.Map Int Int)
magicDist n = dist n magicNumbers

-- >>> replicateM 200 magicNumbers

avgNumbers ∷ MonadRandom m ⇒ m Int
avgNumbers = length . getDeck . adjCards . Deck <$> shuffleM (getDeck pack)

avgDist ∷ MonadRandom m ⇒ Int → m (M.Map Int Int)
avgDist n = dist n avgNumbers

-- todo generalise with ints for numbers and decks!

-- anything to do with log2 52? Let's generalise.
