module Data.Code.JS.LambSpec where

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
import Control.Category.Execute.JSON
import Data.Code.JS.Lamb
import Prelude hiding ((.), id)
import Test.Hspec                       hiding (runIO)
import Test.Hspec.QuickCheck
import Test.QuickCheck
import Test.QuickCheck.Monadic

spec ∷ Spec
spec = describe "JSLamb" $ do
    describe "bracket" $
        it "is idempotent" $
            executeViaJSON (bracket id :: JSLamb String String) "1" `shouldReturn` "1"
    describe "category" $ do
        it "composes" $
            executeViaJSON (id . id :: JSLamb String String) "1" `shouldReturn` "1"
    describe "cartesian" $ do
        it "copies" $
            executeViaJSON (copy :: JSLamb String (String, String)) "1" `shouldReturn` ("1", "1")
        it "consumes" $
            executeViaJSON (consume :: JSLamb String ()) "1" `shouldReturn` ()
        it "returns fst" $
            executeViaJSON (fst' :: JSLamb (String, Int) String) ("1", 1) `shouldReturn` "1"
        it "returns snd" $
            executeViaJSON (snd' :: JSLamb (Int, String) String) (1, "1") `shouldReturn` "1"
    describe "cocartesian" $ do
        xit "injects Left" $ do
            executeViaJSON (injectL :: JSLamb String (Either String ())) "1" `shouldReturn` (Left "1")
        xit "injects Right" $ do
            executeViaJSON (injectR :: JSLamb String (Either () String)) "1" `shouldReturn` (Right "1")
        describe "unify" $ do
            xit "unifies Left" $
                executeViaJSON (unify :: JSLamb (Either String String) String) (Left "1") `shouldReturn` "1"
            xit "unifies Right" $
                executeViaJSON (unify :: JSLamb (Either String String) String) (Right "1") `shouldReturn` "1"
        describe "tag" $ do
            xit "tags Left" $
                executeViaJSON (tag :: JSLamb (Bool, String) (Either String String)) (False, "1") `shouldReturn` (Left "1")
            xit "tags Right" $
                executeViaJSON (tag :: JSLamb (Bool, String) (Either String String)) (True, "1") `shouldReturn` (Right "1")
    describe "strong" $ do
        it "runs on first" $
            executeViaJSON (first' copy :: JSLamb (String, String) ((String, String), String)) ("1", "2") `shouldReturn` (("1", "1"), "2") 
        it "runs on second" $
            executeViaJSON (second' copy :: JSLamb (String, String) (String, (String, String))) ("1", "2") `shouldReturn` ("1", ("2", "2"))
    describe "choice" $ do
        describe "left'" $
            -- it "runs on left" $
            --     executeViaJSON (left' copy :: JSLamb (Either String Int) (Either (String, String) Int)) (Left "1") `shouldReturn` (Right (Left ("1", "1")))
            xit "doesn't run on right" $
                executeViaJSON (left' copy :: JSLamb (Either String Int) (Either (String, String) Int)) (Right 1) `shouldReturn` (Right 1)
        xdescribe "right'" $ do
            xit "doesn't run on left" $
                executeViaJSON (right' copy :: JSLamb (Either String Int) (Either String (Int, Int))) (Left "1") `shouldReturn` (Left "1")
            xit "runs on right" $
                executeViaJSON (right' copy :: JSLamb (Either String Int) (Either String (Int, Int))) (Right 1) `shouldReturn` (Right (1, 1))
    xdescribe "symmetric" $ do
        xit "swaps" $
            executeViaJSON (swap :: JSLamb (String, Int) (Int, String)) ("1", 1) `shouldReturn` (1, "1")
        xdescribe "swapEither" $ do
            xit "swaps left" $
                executeViaJSON (swapEither :: JSLamb (Either String String) (Either String String)) (Left "1") `shouldReturn` (Right "1")
            xit "swaps right" $
                executeViaJSON (swapEither :: JSLamb (Either String String) (Either String String)) (Right "1") `shouldReturn` (Left "1")
        it "reassocs" $
            executeViaJSON (reassoc :: JSLamb (String, (Int, Bool)) ((String, Int), Bool)) ("1", (1, True)) `shouldReturn` ((("1", 1), True))
        xdescribe "reassocEither" $ do
            it "reassocs Left" $
                executeViaJSON (reassocEither :: JSLamb (Either String (Either Int Bool)) (Either (Either String Int) Bool)) (Left "1") `shouldReturn` (Left (Left "1"))
            it "reassocs Right (Left)" $
                executeViaJSON (reassocEither :: JSLamb (Either String (Either Int Bool)) (Either (Either String Int) Bool)) (Right (Left 1)) `shouldReturn` (Left (Right 1))
            it "reassoc Right (Right)" $
                executeViaJSON (reassocEither :: JSLamb (Either String (Either Int Bool)) (Either (Either String Int) Bool)) (Right (Right True)) `shouldReturn` (Right True)
    describe "primitive" $ do
        describe "eq" $ do
            it "equal" $
                executeViaJSON (eq :: JSLamb (String, String) Bool) ("a", "a") `shouldReturn` True
            it "not equal" $
                executeViaJSON (eq :: JSLamb (String, String) Bool) ("a", "b") `shouldReturn` False
        it "reverses string" $
            executeViaJSON (reverseString :: JSLamb String String) "abc" `shouldReturn` "cba"
    describe "primitiveconsole" $ pure ()
    describe "primitive extra" $ do
        it "converts int to string" $
            executeViaJSON (intToString :: JSLamb Int String) 1 `shouldReturn` "1"
        xit "concats string" $
            executeViaJSON (concatString :: JSLamb (String, String) String) ("a", "b") `shouldReturn` "ab"
        it "returns const string" $ do
            executeViaJSON (constString "a" :: JSLamb () String) () `shouldReturn` "a"
    describe "numeric" $ do
        it "returns const int" $ do
            executeViaJSON (num 1 :: JSLamb () Int) () `shouldReturn` 1
        it "negates" $ do
            executeViaJSON (negate' :: JSLamb Int Int) 1 `shouldReturn` (-1)
        it "adds" $ do
            executeViaJSON (add :: JSLamb (Int, Int) Int) (1, 2) `shouldReturn` 3
        it "mults" $ do
            executeViaJSON (mult :: JSLamb (Int, Int) Int) (2, 3) `shouldReturn` 6
        it "divs" $ do
            executeViaJSON (div' :: JSLamb (Int, Int) Int) (4, 2) `shouldReturn` 2
        it "mods" $ do
            executeViaJSON (mod' :: JSLamb (Int, Int) Int) (5, 2) `shouldReturn` 1
    describe "executeViaJSON" $ do
        it "returns a string" $
            executeViaJSON (id :: JSLamb String String) "1" `shouldReturn` "1"
        it "returns an int" $
            executeViaJSON (id :: JSLamb Int Int) 1 `shouldReturn` 1
        it "returns a bool" $
            executeViaJSON (id :: JSLamb Bool Bool) True `shouldReturn` True
        it "returns a tuple" $
            executeViaJSON (id :: JSLamb (String, Int) (String, Int)) ("1", 1) `shouldReturn` ("1", 1)
        describe "Either" $ do
            it "returns a Left" $
                executeViaJSON (id :: JSLamb (Either String Int) (Either String Int)) (Left "1") `shouldReturn` (Left "1")
            it "returns a Right" $
                executeViaJSON (id :: JSLamb (Either String Int) (Either String Int)) (Right 1) `shouldReturn` (Right 1)
        describe "Maybe" $ do
            it "returns a Nothing" $
                executeViaJSON (id :: JSLamb (Maybe Int) (Maybe Int)) Nothing `shouldReturn` Nothing
            it "returns a Just" $
                executeViaJSON (id :: JSLamb (Maybe Int) (Maybe Int)) (Just 1) `shouldReturn` (Just 1)
            