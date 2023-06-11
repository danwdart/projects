module Data.Function.GreetSpec where

import Control.Category.Execute.Haskell
import Control.Category.Execute.JSON
import Data.Aeson
import Data.Code.Haskell.Func
import Data.Code.Haskell.Lamb
import Data.Code.JS.Lamb
import Data.Code.PHP.Lamb
import Data.Function.CollatzStep
import Data.Function.Free.Abstract
import Data.Function.Greet
import Data.Function.IsPalindrome
import Data.Function.ReverseInput
import Data.Person
import Data.Primitive.Prims
import Test.Hspec                       hiding (runIO)
import Test.Hspec.QuickCheck
import Test.QuickCheck
import Test.QuickCheck.Monadic

myPerson ∷ Person
myPerson = Person "Dan" 32

myTuple ∷ (String, Int)
myTuple = ("Dan", 32)

spec ∷ Spec
spec = do
    describe "greetData" $ do
        describe "HSFunc" $ do
            xit "is correct" $
                executeViaGHCi (greetData :: HSFunc Person String) myPerson `shouldReturn` (greetData myPerson)
        describe "HSLamb" $ do
            xit "is correct"$ do
                executeViaGHCi (greetData :: HSLamb Person String) myPerson `shouldReturn` (greetData myPerson)
        describe "JSLamb" $ do
            xit "is correct" $ do
                executeViaJSON (greetData :: JSLamb Person String) myPerson `shouldReturn` (greetData myPerson)
        describe "PHPLamb" $ do
            xit "is correct" $ do
                executeViaJSON (greetData :: PHPLamb Person String) myPerson `shouldReturn` (greetData myPerson)
    describe "greetTuple" $ do
        describe "HSFunc" $ do
            it "is correct" $ do
                executeViaGHCi (greetTuple :: HSFunc (String, Int) String) myTuple `shouldReturn` (greetTuple myTuple)
        describe "HSLamb" $ do
            it "is correct" $ do
                executeViaGHCi (greetTuple :: HSLamb (String, Int) String) myTuple `shouldReturn` (greetTuple myTuple)
        describe "JSLamb" $ do
            xit "is correct" $ do
                executeViaJSON (greetTuple :: JSLamb (String, Int) String) myTuple `shouldReturn` (greetTuple myTuple)
        describe "PHPLamb" $ do
            xit "is correct" $ do
                executeViaJSON (greetTuple :: PHPLamb (String, Int) String) myTuple `shouldReturn` (greetTuple myTuple)
