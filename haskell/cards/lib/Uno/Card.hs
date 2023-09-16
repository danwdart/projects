{-# LANGUAGE LambdaCase #-}
{-# OPTIONS_GHC -Wno-partial-fields -Wno-orphans #-}

module Uno.Card where

import           ANSI
import           Data.List.Extra
import qualified Data.List.NonEmpty as LNE
import qualified Uno.Action.Bounded as ActionBounded
import qualified Uno.Colour.Bounded as ColourBounded
import qualified Uno.Value.Bounded  as ValueBounded
import qualified Uno.Wild.Bounded   as WildBounded
import qualified System.Console.ANSI as SysConsoleANSI

data Card value colour action wild = NumberCard {
    value  :: value,
    colour :: colour
} | ActionCard {
    action :: action,
    colour :: colour
} | WildCard wild deriving stock (Eq, Show) -- we're modelling wild as non-action so action can specify colour

instance (ANSI value, ANSI colour, ANSI action, ANSI wild) => ANSI (Card value colour action wild) where
    renderANSI = \case
        NumberCard value colour -> renderANSI colour <> "[" <> renderANSI value <> "]" <> SysConsoleANSI.setSGRCode [SysConsoleANSI.Reset]
        ActionCard action colour -> renderANSI colour <> "[" <> renderANSI action <> "]" <> SysConsoleANSI.setSGRCode [SysConsoleANSI.Reset]
        WildCard wild -> "[" <> renderANSI wild <> "]"

type CardBounded = Card ValueBounded.Value ColourBounded.Colour ActionBounded.Action WildBounded.Wild

-- | Determine whether matching card
-- isMatching :: CardBounded -> CardBounded -> Bool
-- isMatching a b = undefined

-- | Determine which card (if any) can match. Nothing if draw another.
-- whichCanMatch :: CardBounded -> [CardBounded] -> NextAction
-- whichCanMatch with options = undefined

allNumberCards :: LNE.NonEmpty CardBounded
allNumberCards = LNE.fromList $
    (NumberCard ValueBounded.Zero <$> enumerate) <>
    concat (replicate 2 (NumberCard <$> [ValueBounded.One .. ValueBounded.Nine] <*> enumerate))

allActionCards :: LNE.NonEmpty CardBounded
allActionCards = LNE.fromList $ concat (replicate 2 (ActionCard <$> enumerate <*> enumerate))

allWildCards :: LNE.NonEmpty CardBounded
allWildCards =
    LNE.fromList (replicate 4 (WildCard WildBounded.Wild)) <>
    LNE.singleton (WildCard WildBounded.WildShuffleHands) <>
    LNE.fromList (replicate 4 (WildCard WildBounded.WildDrawFour)) <>
    LNE.fromList (replicate 3 (WildCard WildBounded.WildCustomisable))

allCards :: LNE.NonEmpty CardBounded
allCards = allNumberCards <> allActionCards <> allWildCards