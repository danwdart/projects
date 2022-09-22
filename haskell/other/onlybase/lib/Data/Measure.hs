module Data.Measure where

-- todo gadt this shit

newtype Inverse a = Inverse a

newtype Relative a = Relative a

newtype Force = Force Double

newtype Pressure = Pressure Double

newtype Length = Length Double

newtype Radius = Radius Length

newtype Circumference = Circumference Length

newtype Width = Width Double

newtype Height = Height Double

newtype Depth = Depth Double

newtype Breadth = Breadth Double

newtype Area = Area Double

newtype Volume = Volume Double

newtype Distance = Distance Double

newtype Speed = Speed Double

newtype Displacement = Displacement Double

newtype Velocity = Velocity Double

newtype Time = Time Double

newtype Charge = Charge Double

newtype PotentialDifference = PotentialDifference Double

newtype Resistance = Resistance Double

newtype Current = Current Double

newtype Power = Power Double

newtype Energy = Energy Double

data Multiplication a b = Multiplication a b