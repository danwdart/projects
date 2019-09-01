module Lib.Game.Monopoly.Rules where

import qualified Data.Set as Set
import Data.Set (Set)

data PropertyRule = ForceBuy | ConfirmBuy | Auction deriving (Eq, Ord)
data Rule = HitGoExactlyReceive400 | FreeParkingMoney deriving (Eq, Ord)

instance Show Rule where
    show HitGoExactlyReceive400 = "When landing exactly on GO, you receive 400"
    show FreeParkingMoney = "Taxes and charges from random items go to the middle. When landing on Free Parking, the player receives the entire stack of cash in the middle."

data Rules = StandardRules | ExtraRules (Set Rule) deriving (Eq, Show)
