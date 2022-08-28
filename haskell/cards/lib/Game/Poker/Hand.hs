{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE TypeFamilies #-}

module Game.Poker.Hand where

import GHC.Exts

{-# ANN module "HLint: ignore Avoid restricted function" #-}

-- fixed length list
data StaticPokerHand a = StaticPokerHand {
    _1 :: a,
    _2 :: a,
    _3 :: a,
    _4 :: a,
    _5 :: a
} deriving Show

instance IsList (StaticPokerHand a) where

    type (Item (StaticPokerHand a)) = a

    fromList [a, b, c, d, e] = StaticPokerHand a b c d e
    fromList _ = error "Needs 5 elements"
    
    toList (StaticPokerHand a b c d e) = [a, b, c, d, e]

-- we could probably implement that as a typed length list...
-- or even a regular list...

anyNSame :: Eq a => StaticPokerHand a -> Bool
anyNSame (StaticPokerHand a b c d e) =
    -- come on, we've got to get something better than that!
    -- todo: refactor
    a == b ||
    a == c ||
    a == d ||
    a == e ||
    b == c ||
    b == d ||
    b == e ||
    c == d ||
    c == e ||
    d == e

-- $> phint
phint :: StaticPokerHand Int
phint = [1, 2, 3, 4, 5]