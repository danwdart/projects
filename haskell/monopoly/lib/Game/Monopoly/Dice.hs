module Game.Monopoly.Dice where

import Control.Monad.Random

randomRoll :: MonadRandom m => m (Int, Bool)
randomRoll = do
    die1 <- randomR (1, 6)
    die2 <- randomR (1, 6)
    pure (die1 + die2, die1 == die2)