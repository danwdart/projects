{-# LANGUAGE DataKinds    #-}
{-# LANGUAGE TypeFamilies #-}

{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import           Data.Kind
import           GHC.TypeNats (Nat)

class Unit x

class (Unit x) => DisplacementUnit x where
class (Unit x) => TimeUnit x where
class (Unit x) => VelocityUnit x
class (Unit x) => AccelerationUnit x

newtype Metre x = Metre x deriving stock (Show) deriving newtype (Num, Fractional, Unit, DisplacementUnit)
type Metres = Metre Double

newtype Foot x = Foot x deriving stock (Show) deriving newtype (Num, Fractional, Unit, DisplacementUnit)
type Feet = Foot Double

newtype Second x = Second x deriving stock (Show) deriving newtype (Num, Fractional, Unit, TimeUnit)
type Seconds = Second Double

newtype Minute x = Minute x deriving stock (Show) deriving newtype (Num, Fractional, Unit, TimeUnit)
type Minutes = Minute Double

data (a / b) = a :/: b deriving stock (Show)

data family (^) (a :: k) (b :: Nat) :: k

type family Pow (a :: Type) (b :: Nat) :: Type

type Area = Metres ^ 2
type Volume = Metres ^ 3
type MPS = Metres / Seconds
type MPSPS = Metres / Seconds ^ 2

myVel ∷ MPS
myVel = Metre 1 :/: Second 1

-- myAcc :: MPSPS
-- myAcc = (Metre 1.0 :/: Second 1.0) :/: Second 1.0

main ∷ IO ()
main = pure ()
