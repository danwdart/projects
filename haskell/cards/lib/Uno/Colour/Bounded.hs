module Uno.Colour.Bounded where

import ANSI
import qualified System.Console.ANSI as SysConsoleANSI

data Colour = Red | Blue | Yellow | Green deriving stock (Show, Eq, Ord, Bounded, Enum)

instance ANSI Colour where
    renderANSI Red = SysConsoleANSI.setSGRCode [SysConsoleANSI.SetConsoleIntensity SysConsoleANSI.BoldIntensity, SysConsoleANSI.SetColor SysConsoleANSI.Foreground SysConsoleANSI.Vivid SysConsoleANSI.Red]
    renderANSI Blue = SysConsoleANSI.setSGRCode [SysConsoleANSI.SetConsoleIntensity SysConsoleANSI.BoldIntensity, SysConsoleANSI.SetColor SysConsoleANSI.Foreground SysConsoleANSI.Vivid SysConsoleANSI.Blue]
    renderANSI Yellow = SysConsoleANSI.setSGRCode [SysConsoleANSI.SetConsoleIntensity SysConsoleANSI.BoldIntensity, SysConsoleANSI.SetColor SysConsoleANSI.Foreground SysConsoleANSI.Vivid SysConsoleANSI.Yellow]
    renderANSI Green = SysConsoleANSI.setSGRCode [SysConsoleANSI.SetConsoleIntensity SysConsoleANSI.BoldIntensity, SysConsoleANSI.SetColor SysConsoleANSI.Foreground SysConsoleANSI.Vivid SysConsoleANSI.Green]