module Game.Monopoly.Rules where

import Data.Set (Set)

data PropertyRule = ForceBuy | ConfirmBuy | Auction deriving stock (Eq, Ord)
data Rule = HitGoExactlyReceive400 | FreeParkingMoney | ThrowThreeDoublesGoToJail deriving stock (Eq, Ord)

instance Show Rule where
    show HitGoExactlyReceive400 = "When landing exactly on GO, you receive 400"
    show FreeParkingMoney = "Taxes and charges from random items go to the middle. When landing on Free Parking, the player receives the entire stack of cash in the middle."
    show ThrowThreeDoublesGoToJail = "Throwing three doubles instantly makes the player go to jail."

data Rules = StandardRules | ExtraRules (Set Rule) deriving stock (Eq, Show)
