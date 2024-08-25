{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-unused-packages #-}

-- import Control.Exception
import Control.Exception.RangeException
import Data.Text.Lazy.Builder qualified as TB
import Data.Text.Display (Display(..))
import Numeric.Natural
import Numeric.Range

-- Countdown.

main :: IO ()
main = pure ()

-- Tree of possibilities
class NumberCard a where
    getValue :: a -> Int

data SmallNumber = C1 | C2 | C3 | C4 | C5 | C6 | C7 | C8 | C9 | C10 deriving stock (Show, Eq, Ord, Enum)

instance Display SmallNumber where
    displayBuilder = TB.fromString . show . getValue

-- >>> getValue C4
-- 4
--
instance NumberCard SmallNumber where
    getValue = succ . fromEnum 

data LargeNumber = C25 | C50 | C75 | C100 deriving stock (Show, Eq, Ord, Enum)

instance Display LargeNumber where
    displayBuilder = TB.fromString . show . getValue

-- >>> getValue C25
-- 25
--

instance NumberCard LargeNumber where
    getValue = (*25) . succ . fromEnum

data Strategy = AllSmall | OneLarge | TwoLarge | ThreeLarge | FourLarge deriving stock (Show, Eq, Ord, Enum)

-- Targets

newtype Target = Target {
    getTarget :: Natural
}

instance Bounded Target where
    minBound = Target 100
    maxBound = Target 999

mkTarget :: Natural -> Either (RangeException Natural) Target
mkTarget = mkWithRange Target 100 999

-- Solve it?

-- What targets are possible for these numbers?

-- What numbers are necessary for this target?

-- What's the fastest way to get this target from these numbers?
