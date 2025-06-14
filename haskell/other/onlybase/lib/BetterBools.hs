{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE NoGeneralisedNewtypeDeriving #-}
{-# LANGUAGE Safe                         #-}
{-# LANGUAGE UnicodeSyntax                #-}

module BetterBools where

newtype LightState = LightState Bool

data Lights = Off | On deriving stock (Enum, Eq, Ord, Show)

data BoolyThing
data OtherBoolyThing

newtype Booly a = Booly Bool deriving stock (Eq, Ord, Show)

-- nicer alias
newtype If a = If Bool deriving stock (Eq, Ord, Show)

type IfOpt1 = If "we should enable option 1"

type IfOpt2 = If "we should enable option 2"

yes :: If a
yes = If True

no :: If a
no = If False

data SampleOptions = SampleOptions {
    option1 :: IfOpt1,
    option2 :: IfOpt2
} deriving (Eq, Ord, Show)

-- Whilst the values look the same (option)

-- >>> SampleOptions { option1 = yes, option2 = no }
-- SampleOptions {option1 = If True, option2 = If False}
--

-- >>> SampleOptions yes no
-- SampleOptions {option1 = If True, option2 = If False}
--

optChoice1 :: IfOpt1
optChoice1 = yes

optChoice2 :: IfOpt2
optChoice2 = no

-- >>> SampleOptions (yes :: IfOpt2) (no :: IfOpt1)
-- <interactive>:5968:17-29: error: [GHC-83865]
--     • Couldn't match type ‘"we should enable option 2"’
--                      with ‘"we should enable option 1"’
--       Expected: IfOpt1
--         Actual: IfOpt2
--     • In the first argument of ‘SampleOptions’, namely
--         ‘(yes :: IfOpt2)’
--       In the expression: SampleOptions (yes :: IfOpt2) (no :: IfOpt1)
--       In an equation for ‘it’:
--           it = SampleOptions (yes :: IfOpt2) (no :: IfOpt1)
-- <BLANKLINE>
-- <interactive>:5968:33-44: error: [GHC-83865]
--     • Couldn't match type ‘"we should enable option 1"’
--                      with ‘"we should enable option 2"’
--       Expected: IfOpt2
--         Actual: IfOpt1
--     • In the second argument of ‘SampleOptions’, namely
--         ‘(no :: IfOpt1)’
--       In the expression: SampleOptions (yes :: IfOpt2) (no :: IfOpt1)
--       In an equation for ‘it’:
--           it = SampleOptions (yes :: IfOpt2) (no :: IfOpt1)
-- <BLANKLINE>
--


-- The docs are nicer:

-- >>> :t SampleOptions
-- SampleOptions
--   :: If "we should enable option 1"
--      -> If "we should enable option 2" -> SampleOptions
--


-- >>> Booly True :: Booly BoolyThing
-- Booly True
--

-- >>> Booly False :: Booly OtherBoolyThing
-- Booly False
--

-- We don't even need to make useless data types up...

-- >>> :set -XDataKinds
-- >>> Booly True :: Booly "Should we be doing this right now"
-- Booly True
--

-- >>> :t Booly True :: Booly "Should we be doing this right now"
-- Booly True :: Booly "Should we be doing this right now"
--   :: Booly "Should we be doing this right now"
--

-- >>> (coerceEnum On :: Bool)
-- True
--

coerceEnum ∷ (Enum a, Enum b) ⇒ a → b
coerceEnum = toEnum . fromEnum
