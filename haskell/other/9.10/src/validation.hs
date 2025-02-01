{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TypeFamilies         #-}
{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main (main) where

import Data.Either.Validation
import Data.Foldable
import Data.HKD.Generic
import Data.Thriple
-- import Data.Thriple.Things

ke, je, me ∷ Either String String
ke = Left "Why?: "
je = Left "This"
me = Right "Yeaah."

kv, jv, mv ∷ Validation String String
kv = Failure "Why?: "
jv = Failure "This"
mv = Success "Yeaah."

tripletMaybes ∷ [Thriple Maybe]
tripletMaybes = [
    Thriple { a = Just 1, b = Just "Yeah", c = Just False },
    Thriple { a = Just 1, b = Nothing, c = Just False },
    Thriple { a = Just 1, b = Nothing, c = Nothing },
    Thriple { a = Nothing, b = Nothing, c = Nothing }
    ]

tripletEithers ∷ [Thriple (Either [String])]
tripletEithers = [
    Thriple { a = Right 1, b = Right "Yeah", c = Right False },
    Thriple { a = Right 1, b = Left ["No"], c = Right True },
    Thriple { a = Right 1, b = Left ["No"], c = Left ["Nah"] },
    Thriple { a = Left ["N"], b = Left ["No"], c = Left ["Nah"] }
    ]

tripletValidations ∷ [Thriple (Validation [String])]
tripletValidations = [
    Thriple { a = Success 1, b = Success "Yeah", c = Success False },
    Thriple { a = Success 1, b = Failure ["No"], c = Success True },
    Thriple { a = Success 1, b = Failure ["No"], c = Failure ["Nah"] },
    Thriple { a = Failure ["N"], b = Failure ["No"], c = Failure ["Nah"] }
    ]

reversedTripletMaybes ∷ [Maybe Triple]
reversedTripletMaybes = hsequence <$> tripletMaybes

reversedTripletEithers ∷ [Either [String] Triple]
reversedTripletEithers = hsequence <$> tripletEithers

reversedTripletValidations ∷ [Validation [String] Triple]
reversedTripletValidations = hsequence <$> tripletValidations

main ∷ IO ()
main = do
    print $ ke <> je
    print me
    print $ kv <> jv
    print mv
    traverse_ print reversedTripletMaybes
    traverse_ print reversedTripletEithers
    traverse_ print reversedTripletValidations
