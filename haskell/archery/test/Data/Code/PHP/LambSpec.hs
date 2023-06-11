module Data.Code.PHP.LambSpec where

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
import Data.Code.PHP.Lamb
import Prelude hiding ((.), id)
import Test.Hspec                       hiding (runIO)
import Test.Hspec.QuickCheck
import Test.QuickCheck
import Test.QuickCheck.Monadic

spec ∷ Spec
spec = xdescribe "PHPLamb" $ do
    describe "bracket" $
        it "is idempotent" $
            executeViaJSON (bracket id :: PHPLamb String String) "1" `shouldReturn` "1"
    describe "category" $ do
        it "composes" $
            executeViaJSON (id . id :: PHPLamb String String) "1" `shouldReturn` "1"
    describe "cartesian" $ do
        it "copies" $
            executeViaJSON (copy :: PHPLamb String (String, String)) "1" `shouldReturn` ("1", "1")
        it "consumes" $
            executeViaJSON (consume :: PHPLamb String ()) "1" `shouldReturn` ()
        it "returns fst" $
            executeViaJSON (fst' :: PHPLamb (String, Int) String) ("1", 1) `shouldReturn` "1"
        it "returns snd" $
            executeViaJSON (snd' :: PHPLamb (Int, String) String) (1, "1") `shouldReturn` "1"
    describe "cocartesian" $ do
        it "injects Left" $ do
            executeViaJSON (injectL :: PHPLamb String (Either String ())) "1" `shouldReturn` (Left "1")
        it "injects Right" $ do
            executeViaJSON (injectR :: PHPLamb String (Either () String)) "1" `shouldReturn` (Right "1")
        describe "unify" $ do
            it "unifies Left" $
                executeViaJSON (unify :: PHPLamb (Either String String) String) (Left "1") `shouldReturn` "1"
            it "unifies Right" $
                executeViaJSON (unify :: PHPLamb (Either String String) String) (Right "1") `shouldReturn` "1"
        describe "tag" $ do
            it "tags Left" $
                executeViaJSON (tag :: PHPLamb (Bool, String) (Either String String)) (False, "1") `shouldReturn` (Left "1")
            it "tags Right" $
                executeViaJSON (tag :: PHPLamb (Bool, String) (Either String String)) (True, "1") `shouldReturn` (Right "1")
    describe "strong" $ do
        it "runs on first" $
            executeViaJSON (first' copy :: PHPLamb (String, String) ((String, String), String)) ("1", "2") `shouldReturn` (("1", "1"), "2") 
        it "runs on second" $
            executeViaJSON (second' copy :: PHPLamb (String, String) (String, (String, String))) ("1", "2") `shouldReturn` ("1", ("2", "2"))
    describe "choice" $ do
        describe "left'" $
            -- it "runs on left" $
            --     executeViaJSON (left' copy :: PHPLamb (Either String Int) (Either (String, String) Int)) (Left "1") `shouldReturn` (Right (Left ("1", "1")))
            it "doesn't run on right" $
                executeViaJSON (left' copy :: PHPLamb (Either String Int) (Either (String, String) Int)) (Right 1) `shouldReturn` (Right 1)
        describe "right'" $ do
            it "doesn't run on left" $
                executeViaJSON (right' copy :: PHPLamb (Either String Int) (Either String (Int, Int))) (Left "1") `shouldReturn` (Left "1")
            it "runs on right" $
                executeViaJSON (right' copy :: PHPLamb (Either String Int) (Either String (Int, Int))) (Right 1) `shouldReturn` (Right (1, 1))
    describe "symmetric" $ do
        it "swaps" $
            executeViaJSON (swap :: PHPLamb (String, Int) (Int, String)) ("1", 1) `shouldReturn` (1, "1")
        describe "swapEither" $ do
            it "swaps left" $
                executeViaJSON (swapEither :: PHPLamb (Either String String) (Either String String)) (Left "1") `shouldReturn` (Right "1")
            it "swaps right" $
                executeViaJSON (swapEither :: PHPLamb (Either String String) (Either String String)) (Right "1") `shouldReturn` (Left "1")
        it "reassocs" $
            executeViaJSON (reassoc :: PHPLamb (String, (Int, Bool)) ((String, Int), Bool)) ("1", (1, True)) `shouldReturn` ((("1", 1), True))
        xdescribe "reassocEither" $ do
            it "reassocs Left" $
                executeViaJSON (reassocEither :: PHPLamb (Either String (Either Int Bool)) (Either (Either String Int) Bool)) (Left "1") `shouldReturn` (Left (Left "1"))
            it "reassocs Right (Left)" $
                executeViaJSON (reassocEither :: PHPLamb (Either String (Either Int Bool)) (Either (Either String Int) Bool)) (Right (Left 1)) `shouldReturn` (Left (Right 1))
            it "reassoc Right (Right)" $
                executeViaJSON (reassocEither :: PHPLamb (Either String (Either Int Bool)) (Either (Either String Int) Bool)) (Right (Right True)) `shouldReturn` (Right True)
    describe "primitive" $ do
        describe "eq" $ do
            it "equal" $
                executeViaJSON (eq :: PHPLamb (String, String) Bool) ("a", "a") `shouldReturn` True
            it "not equal" $
                executeViaJSON (eq :: PHPLamb (String, String) Bool) ("a", "b") `shouldReturn` False
        it "reverses string" $
            executeViaJSON (reverseString :: PHPLamb String String) "abc" `shouldReturn` "cba"
    describe "primitiveconsole" $ pure ()
    describe "primitive extra" $ do
        it "converts int to string" $
            executeViaJSON (intToString :: PHPLamb Int String) 1 `shouldReturn` "1"
        it "concats string" $
            executeViaJSON (concatString :: PHPLamb (String, String) String) ("a", "b") `shouldReturn` "ab"
        it "returns const string" $ do
            executeViaJSON (constString "a" :: PHPLamb () String) () `shouldReturn` "a"
    describe "numeric" $ do
        it "returns const int" $ do
            executeViaJSON (num 1 :: PHPLamb () Int) () `shouldReturn` 1
        it "negates" $ do
            executeViaJSON (negate' :: PHPLamb Int Int) 1 `shouldReturn` (-1)
        it "adds" $ do
            executeViaJSON (add :: PHPLamb (Int, Int) Int) (1, 2) `shouldReturn` 3
        it "mults" $ do
            executeViaJSON (mult :: PHPLamb (Int, Int) Int) (2, 3) `shouldReturn` 6
        it "divs" $ do
            executeViaJSON (div' :: PHPLamb (Int, Int) Int) (4, 2) `shouldReturn` 2
        it "mods" $ do
            executeViaJSON (mod' :: PHPLamb (Int, Int) Int) (5, 2) `shouldReturn` 1
    describe "executeViaJSON" $ do
        it "returns a string" $
            executeViaJSON (id :: PHPLamb String String) "1" `shouldReturn` "1"
        it "returns an int" $
            executeViaJSON (id :: PHPLamb Int Int) 1 `shouldReturn` 1
        it "returns a bool" $
            executeViaJSON (id :: PHPLamb Bool Bool) True `shouldReturn` True
        it "returns a tuple" $
            executeViaJSON (id :: PHPLamb (String, Int) (String, Int)) ("1", 1) `shouldReturn` ("1", 1)
        describe "Either" $ do
            it "returns a Left" $
                executeViaJSON (id :: PHPLamb (Either String Int) (Either String Int)) (Left "1") `shouldReturn` (Left "1")
            it "returns a Right" $
                executeViaJSON (id :: PHPLamb (Either String Int) (Either String Int)) (Right 1) `shouldReturn` (Right 1)
        describe "Maybe" $ do
            it "returns a Nothing" $
                executeViaJSON (id :: PHPLamb (Maybe Int) (Maybe Int)) Nothing `shouldReturn` Nothing
            it "returns a Just" $
                executeViaJSON (id :: PHPLamb (Maybe Int) (Maybe Int)) (Just 1) `shouldReturn` (Just 1)