module Game.Monopoly.Dice where

import Control.Monad.IO.Class
import Control.Monad.Random

randomRoll ∷ (MonadRandom m, MonadIO m) ⇒ m (Int, Bool)
randomRoll = do
    die1 <- randomRIO (1, 6) -- randomR wouldn't cut it
    die2 <- randomRIO (1, 6)
    pure (die1 + die2, die1 == die2)
{-# INLINABLE randomRoll #-}
