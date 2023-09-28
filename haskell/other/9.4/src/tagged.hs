module Main where

import Data.Tagged

import Data.Proxy
import Data.Void

myValue ∷ Int
myValue = 42

myTaggedValue ∷ Tagged Void Int
myTaggedValue = Tagged 42

myTaggedValue2 ∷ Tagged (Either (IO Void) (Maybe (Proxy (IO Bool)))) String
myTaggedValue2 = Tagged "Why."

myTaggedValueICanReasonablyUseWitnessOn ∷ Tagged Int String
myTaggedValueICanReasonablyUseWitnessOn = Tagged "Well, I guess so."

myRetagged ∷ Tagged String String
myRetagged = retag myTaggedValueICanReasonablyUseWitnessOn

myStringFromThatThingAbove ∷ String
myStringFromThatThingAbove = untag myRetagged

selfTagged ∷ Tagged Int Int
selfTagged = tagSelf 123

untaggedSelf ∷ Int
untaggedSelf = untagSelf selfTagged

evil ∷ Num a ⇒ a
evil = 2

evilTT ∷ Int -- supposed
evilTT = asTaggedTypeOf evil selfTagged

witnessed ∷ String
witnessed = witness myTaggedValueICanReasonablyUseWitnessOn 12

-- @TODO proxy: https://hackage.haskell.org/package/tagged-0.8.6.1/docs/Data-Tagged.html#g:2

main ∷ IO ()
main = do
    print myValue
    print myTaggedValue
    print myTaggedValue2
    print myTaggedValueICanReasonablyUseWitnessOn
    print myRetagged
    print myStringFromThatThingAbove
    print selfTagged
    print untaggedSelf
    print (evil :: Int)
    print evilTT
    print witnessed
