{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE ExistentialQuantification  #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GeneralisedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE PolyKinds                  #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE TypeOperators              #-}

import           GHC.TypeNats (Nat)

class Unit x

class (Unit x) => DisplacementUnit x where
class (Unit x) => TimeUnit x where
class (Unit x) => VelocityUnit x
class (Unit x) => AccelerationUnit x

newtype Metre x = Metre x deriving (Show, Num, Fractional, Unit, DisplacementUnit)
type Metres = Metre Double

newtype Foot x = Foot x deriving (Show, Num, Fractional, Unit, DisplacementUnit)
type Feet = Foot Double

newtype Second x = Second x deriving (Show, Num, Fractional, Unit, TimeUnit)
type Seconds = Second Double

newtype Minute x = Minute x deriving (Show, Num, Fractional, Unit, TimeUnit)
type Minutes = Minute Double

data (a / b) = a :/: b deriving (Show)

data family (^) (a :: k) (b :: Nat) :: k

type family Pow (a :: *) (b :: Nat) :: *

type Area = Metres ^ 2
type Volume = Metres ^ 3
type MPS = Metres / Seconds
type MPSPS = Metres / Seconds ^ 2

myVel :: MPS
myVel = Metre 1 :/: Second 1

-- myAcc :: MPSPS
-- myAcc = (Metre 1.0 :/: Second 1.0) :/: Second 1.0

main :: IO ()
main = return ()
