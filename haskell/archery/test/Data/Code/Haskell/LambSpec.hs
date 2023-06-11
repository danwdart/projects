module Data.Code.Haskell.LambSpec where

import Control.Category
import Control.Category.Bracket
import Control.Category.Cartesian
import Control.Category.Cocartesian
import Control.Category.Strong
import Control.Category.Choice
import Control.Category.Symmetric
import Control.Category.Primitive.Abstract
import Control.Category.Primitive.Extra
import Control.Category.Numeric
import Control.Category.Execute.Haskell
import Data.Code.Haskell.Lamb
import Prelude hiding ((.), id)
import Test.Hspec                       hiding (runIO)
import Test.Hspec.QuickCheck
import Test.QuickCheck
import Test.QuickCheck.Monadic

spec ∷ Spec
spec = describe "HSLamb" $ do
    describe "bracket" $
        it "is idempotent" $
            executeViaGHCi (bracket id :: HSLamb String String) "1" `shouldReturn` "1"
    describe "category" $ do
        it "composes" $
            executeViaGHCi (id . id :: HSLamb String String) "1" `shouldReturn` "1"
    describe "cartesian" $ do
        it "copies" $
            executeViaGHCi (copy :: HSLamb String (String, String)) "1" `shouldReturn` ("1", "1")
        it "consumes" $
            executeViaGHCi (consume :: HSLamb String ()) "1" `shouldReturn` ()
        it "returns fst" $
            executeViaGHCi (fst' :: HSLamb (String, Int) String) ("1", 1) `shouldReturn` "1"
        it "returns snd" $
            executeViaGHCi (snd' :: HSLamb (Int, String) String) (1, "1") `shouldReturn` "1"
    describe "cocartesian" $ do
        it "injects Left" $ do
            executeViaGHCi (injectL :: HSLamb String (Either String ())) "1" `shouldReturn` (Left "1")
        it "injects Right" $ do
            executeViaGHCi (injectR :: HSLamb String (Either () String)) "1" `shouldReturn` (Right "1")
        describe "unify" $ do
            xit "unifies Left" $
                executeViaGHCi (unify :: HSLamb (Either String String) String) (Left "1") `shouldReturn` "1"
            xit "unifies Right" $
                executeViaGHCi (unify :: HSLamb (Either String String) String) (Right "1") `shouldReturn` "1"
        describe "tag" $ do
            it "tags Left" $
                executeViaGHCi (tag :: HSLamb (Bool, String) (Either String String)) (False, "1") `shouldReturn` (Left "1")
            it "tags Right" $
                executeViaGHCi (tag :: HSLamb (Bool, String) (Either String String)) (True, "1") `shouldReturn` (Right "1")
    describe "strong" $ do
        it "runs on first" $
            executeViaGHCi (first' copy :: HSLamb (String, String) ((String, String), String)) ("1", "2") `shouldReturn` (("1", "1"), "2") 
        it "runs on second" $
            executeViaGHCi (second' copy :: HSLamb (String, String) (String, (String, String))) ("1", "2") `shouldReturn` ("1", ("2", "2"))
    describe "choice" $ do
        describe "left'" $
            -- it "runs on left" $
            --     executeViaGHCi (left' copy :: HSLamb (Either String Int) (Either (String, String) Int)) (Left "1") `shouldReturn` (Left ("1", "1"))
            xit "doesn't run on right" $
                executeViaGHCi (left' copy :: HSLamb (Either String Int) (Either (String, String) Int)) (Right 1) `shouldReturn` (Right 1)
        describe "right'" $ do
            xit "doesn't run on left" $
                executeViaGHCi (right' copy :: HSLamb (Either String Int) (Either String (Int, Int))) (Left "1") `shouldReturn` (Left "1")
            xit "runs on right" $
                executeViaGHCi (right' copy :: HSLamb (Either String Int) (Either String (Int, Int))) (Right 1) `shouldReturn` (Right (1, 1))
    describe "symmetric" $ do
        it "swaps" $
            executeViaGHCi (swap :: HSLamb (String, Int) (Int, String)) ("1", 1) `shouldReturn` (1, "1")
        describe "swapEither" $ do
            xit "swaps left" $
                executeViaGHCi (swapEither :: HSLamb (Either String String) (Either String String)) (Left "1") `shouldReturn` (Right "1")
            xit "swaps right" $
                executeViaGHCi (swapEither :: HSLamb (Either String String) (Either String String)) (Right "1") `shouldReturn` (Left "1")
        it "reassocs" $
            executeViaGHCi (reassoc :: HSLamb (String, (Int, Bool)) ((String, Int), Bool)) ("1", (1, True)) `shouldReturn` ((("1", 1), True))
        describe "reassocEither" $ do
            xit "reassocs Left" $
                executeViaGHCi (reassocEither :: HSLamb (Either String (Either Int Bool)) (Either (Either String Int) Bool)) (Left "1") `shouldReturn` (Left (Left "1"))
            xit "reassocs Right (Left)" $
                executeViaGHCi (reassocEither :: HSLamb (Either String (Either Int Bool)) (Either (Either String Int) Bool)) (Right (Left 1)) `shouldReturn` (Left (Right 1))
            xit "reassoc Right (Right)" $
                executeViaGHCi (reassocEither :: HSLamb (Either String (Either Int Bool)) (Either (Either String Int) Bool)) (Right (Right True)) `shouldReturn` (Right True)
    describe "primitive" $ do
        describe "eq" $ do
            it "equal" $
                executeViaGHCi (eq :: HSLamb (String, String) Bool) ("a", "a") `shouldReturn` True
            it "not equal" $
                executeViaGHCi (eq :: HSLamb (String, String) Bool) ("a", "b") `shouldReturn` False
        it "reverses string" $
            executeViaGHCi (reverseString :: HSLamb String String) "abc" `shouldReturn` "cba"
    describe "primitiveconsole" $ pure ()
    describe "primitive extra" $ do
        it "converts int to string" $
            executeViaGHCi (intToString :: HSLamb Int String) 1 `shouldReturn` "1"
        it "concats string" $
            executeViaGHCi (concatString :: HSLamb (String, String) String) ("a", "b") `shouldReturn` "ab"
        it "returns const string" $ do
            executeViaGHCi (constString "a" :: HSLamb () String) () `shouldReturn` "a"
    describe "numeric" $ do
        it "returns const int" $ do
            executeViaGHCi (num 1 :: HSLamb () Int) () `shouldReturn` 1
        it "negates" $ do
            executeViaGHCi (negate' :: HSLamb Int Int) 1 `shouldReturn` (-1)
        it "adds" $ do
            executeViaGHCi (add :: HSLamb (Int, Int) Int) (1, 2) `shouldReturn` 3
        it "mults" $ do
            executeViaGHCi (mult :: HSLamb (Int, Int) Int) (2, 3) `shouldReturn` 6
        it "divs" $ do
            executeViaGHCi (div' :: HSLamb (Int, Int) Int) (4, 2) `shouldReturn` 2
        it "mods" $ do
            executeViaGHCi (mod' :: HSLamb (Int, Int) Int) (5, 2) `shouldReturn` 1
    describe "executeViaGHCi" $ do
        it "returns a string" $
            executeViaGHCi (id :: HSLamb String String) "1" `shouldReturn` "1"
        it "returns an int" $
            executeViaGHCi (id :: HSLamb Int Int) 1 `shouldReturn` 1
        it "returns a bool" $
            executeViaGHCi (id :: HSLamb Bool Bool) True `shouldReturn` True
        it "returns a tuple" $
            executeViaGHCi (id :: HSLamb (String, Int) (String, Int)) ("1", 1) `shouldReturn` ("1", 1)
        describe "Either" $ do
            it "returns a Left" $
                executeViaGHCi (id :: HSLamb (Either String Int) (Either String Int)) (Left "1") `shouldReturn` (Left "1")
            it "returns a Right" $
                executeViaGHCi (id :: HSLamb (Either String Int) (Either String Int)) (Right 1) `shouldReturn` (Right 1)
        describe "Maybe" $ do
            it "returns a Nothing" $
                executeViaGHCi (id :: HSLamb (Maybe Int) (Maybe Int)) Nothing `shouldReturn` Nothing
            it "returns a Just" $
                executeViaGHCi (id :: HSLamb (Maybe Int) (Maybe Int)) (Just 1) `shouldReturn` (Just 1)
            