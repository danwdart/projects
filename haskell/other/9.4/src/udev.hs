{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Trustworthy       #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-unused-imports #-}

module Main (main) where

import System.UDev

main ∷ IO ()
main = withUDev $ \udev -> do
    -- hwdb <- newHWDB udev
    enum <- newEnumerate udev
    scanDevices enum
    scanSubsystems enum
    mentry <- getListEntry enum
    name <- case mentry of
        Nothing    -> pure ""
        Just entry -> getName entry
    print name
