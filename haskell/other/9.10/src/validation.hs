{-# LANGUAGE TypeFamilies         #-}
{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main where

import Data.Either.Validation
import Data.HKD.Generic
import Data.Thriple

ke ∷ Either String String
ke = Left "Why?: "

je ∷ Either String String
je = Left "This"

me ∷ Either String String
me = Right "Yeaah."

k ∷ Validation String String
k = Failure "Why?: "

j ∷ Validation String String
j = Failure "This"

m ∷ Validation String String
m = Success "Yeaah."

tripletMaybeGood ∷ Thriple Maybe
tripletMaybeGood = Thriple { a = Just 1, b = Just "Yeah", c = Just False }

tripletMaybeSemiBad ∷ Thriple Maybe
tripletMaybeSemiBad = Thriple { a = Just 1, b = Nothing, c = Just False }

tripletMaybePrettyBad ∷ Thriple Maybe
tripletMaybePrettyBad = Thriple { a = Just 1, b = Nothing, c = Nothing }

tripletMaybeAwful ∷ Thriple Maybe
tripletMaybeAwful = Thriple { a = Nothing, b = Nothing, c = Nothing }


tripletEitherGood ∷ Thriple (Either [String])
tripletEitherGood = Thriple { a = Right 1, b = Right "Yeah", c = Right False }

tripletEitherSemiBad ∷ Thriple (Either [String])
tripletEitherSemiBad = Thriple { a = Right 1, b = Left ["No"], c = Right True }

tripletEitherPrettyBad ∷ Thriple (Either [String])
tripletEitherPrettyBad = Thriple { a = Right 1, b = Left ["No"], c = Left ["Nah"] }

tripletEitherAwful ∷ Thriple (Either [String])
tripletEitherAwful = Thriple { a = Left ["N"], b = Left ["No"], c = Left ["Nah"] }


tripletValidationGood ∷ Thriple (Validation [String])
tripletValidationGood = Thriple { a = Success 1, b = Success "Yeah", c = Success False }

tripletValidationSemiBad ∷ Thriple (Validation [String])
tripletValidationSemiBad = Thriple { a = Success 1, b = Failure ["No"], c = Success True }

tripletValidationPrettyBad ∷ Thriple (Validation [String])
tripletValidationPrettyBad = Thriple { a = Success 1, b = Failure ["No"], c = Failure ["Nah"] }

tripletValidationAwful ∷ Thriple (Validation [String])
tripletValidationAwful = Thriple { a = Failure ["N"], b = Failure ["No"], c = Failure ["Nah"] }

reversedTripletMaybeGood ∷ Maybe Triple
reversedTripletMaybeGood = sequenceG tripletMaybeGood

reversedTripletMaybeSemiBad ∷ Maybe Triple
reversedTripletMaybeSemiBad = sequenceG tripletMaybeSemiBad

reversedTripletMaybePrettyBad ∷ Maybe Triple
reversedTripletMaybePrettyBad = sequenceG tripletMaybePrettyBad

reversedTripletMaybeAwful ∷ Maybe Triple
reversedTripletMaybeAwful = sequenceG tripletMaybeAwful


reversedTripletEitherGood ∷ Either [String] Triple
reversedTripletEitherGood = sequenceG tripletEitherGood

reversedTripletEitherSemiBad ∷ Either [String] Triple
reversedTripletEitherSemiBad = sequenceG tripletEitherSemiBad

reversedTripletEitherPrettyBad ∷ Either [String] Triple
reversedTripletEitherPrettyBad = sequenceG tripletEitherPrettyBad

reversedTripletEitherAwful ∷ Either [String] Triple
reversedTripletEitherAwful = sequenceG tripletEitherAwful


reversedTripletValidationGood ∷ Validation [String] Triple
reversedTripletValidationGood = sequenceG tripletValidationGood

reversedTripletValidationSemiBad ∷ Validation [String] Triple
reversedTripletValidationSemiBad = sequenceG tripletValidationSemiBad

reversedTripletValidationPrettyBad ∷ Validation [String] Triple
reversedTripletValidationPrettyBad = sequenceG tripletValidationPrettyBad

reversedTripletValidationAwful ∷ Validation [String] Triple
reversedTripletValidationAwful = sequenceG tripletValidationAwful

main ∷ IO ()
main = do
    print $ ke <> je
    print me
    print $ k <> j
    print m
    print reversedTripletMaybeGood
    print reversedTripletMaybeSemiBad
    print reversedTripletMaybePrettyBad
    print reversedTripletMaybeAwful
    print reversedTripletEitherGood
    print reversedTripletEitherSemiBad
    print reversedTripletEitherPrettyBad
    print reversedTripletEitherAwful
    print reversedTripletValidationGood
    print reversedTripletValidationSemiBad
    print reversedTripletValidationPrettyBad
    print reversedTripletValidationAwful
