module Uno.Card where

import qualified Uno.Action.Bounded as ActionBounded
import qualified Uno.Colour.Bounded as ColourBounded
import qualified Uno.Value.Bounded as ValueBounded
import qualified Uno.Wild.Bounded as WildBounded

data Card value colour action wild = NumberCard {
    value :: value,
    colour :: colour
} | ActionCard {
    action :: action,
    colour :: colour
} | WildCard wild deriving (Eq, Show) -- we're modelling wild as non-action so action can specify colour

type CardBounded = Card ValueBounded.Value ColourBounded.Colour ActionBounded.Action WildBounded.Wild