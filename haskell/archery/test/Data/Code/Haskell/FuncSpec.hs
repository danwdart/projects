module Data.Code.Haskell.FuncSpec where

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
import Data.Code.Haskell.Func
import Prelude hiding ((.), id)
import Test.Hspec                       hiding (runIO)
import Test.Hspec.QuickCheck
import Test.QuickCheck
import Test.QuickCheck.Monadic

spec ∷ Spec
spec = describe "HSFunc" $ do
    describe "bracket" $
        it "is idempotent" $
            executeViaGHCi (bracket id :: HSFunc String String) "1" `shouldReturn` "1"
    describe "category" $ do
        it "composes" $
            executeViaGHCi (id . id :: HSFunc String String) "1" `shouldReturn` "1"
    describe "cartesian" $ do
        it "copies" $
            executeViaGHCi (copy :: HSFunc String (String, String)) "1" `shouldReturn` ("1", "1")
        it "consumes" $
            executeViaGHCi (consume :: HSFunc String ()) "1" `shouldReturn` ()
        it "returns fst" $
            executeViaGHCi (fst' :: HSFunc (String, Int) String) ("1", 1) `shouldReturn` "1"
        it "returns snd" $
            executeViaGHCi (snd' :: HSFunc (Int, String) String) (1, "1") `shouldReturn` "1"
    describe "cocartesian" $ do
        it "injects Left" $ do
            executeViaGHCi (injectL :: HSFunc String (Either String ())) "1" `shouldReturn` (Left "1")
        it "injects Right" $ do
            executeViaGHCi (injectR :: HSFunc String (Either () String)) "1" `shouldReturn` (Right "1")
        describe "unify" $ do
            xit "unifies Left" $
                executeViaGHCi (unify :: HSFunc (Either String String) String) (Left "1") `shouldReturn` "1"
            xit "unifies Right" $
                executeViaGHCi (unify :: HSFunc (Either String String) String) (Right "1") `shouldReturn` "1"
        describe "tag" $ do
            it "tags Left" $
                executeViaGHCi (tag :: HSFunc (Bool, String) (Either String String)) (False, "1") `shouldReturn` (Left "1")
            it "tags Right" $
                executeViaGHCi (tag :: HSFunc (Bool, String) (Either String String)) (True, "1") `shouldReturn` (Right "1")
    describe "strong" $ do
        it "runs on first" $
            executeViaGHCi (first' copy :: HSFunc (String, String) ((String, String), String)) ("1", "2") `shouldReturn` (("1", "1"), "2") 
        it "runs on second" $
            executeViaGHCi (second' copy :: HSFunc (String, String) (String, (String, String))) ("1", "2") `shouldReturn` ("1", ("2", "2"))
    describe "choice" $ do
        describe "left'" $
            -- it "runs on left" $
            --     executeViaGHCi (left' copy :: HSFunc (Either String Int) (Either (String, String) Int)) (Left "1") `shouldReturn`  (Left ("1", "1")))
            xit "doesn't run on right" $
                executeViaGHCi (left' copy :: HSFunc (Either String Int) (Either (String, String) Int)) (Right 1) `shouldReturn` (Right 1)
        describe "right'" $ do
            xit "doesn't run on left" $
                executeViaGHCi (right' copy :: HSFunc (Either String Int) (Either String (Int, Int))) (Left "1") `shouldReturn` (Left "1")
            xit "runs on right" $
                executeViaGHCi (right' copy :: HSFunc (Either String Int) (Either String (Int, Int))) (Right 1) `shouldReturn` (Right (1, 1))
    describe "symmetric" $ do
        it "swaps" $
            executeViaGHCi (swap :: HSFunc (String, Int) (Int, String)) ("1", 1) `shouldReturn` (1, "1")
        describe "swapEither" $ do
            xit "swaps left" $
                executeViaGHCi (swapEither :: HSFunc (Either String String) (Either String String)) (Left "1") `shouldReturn` (Right "1")
            xit "swaps right" $
                executeViaGHCi (swapEither :: HSFunc (Either String String) (Either String String)) (Right "1") `shouldReturn` (Left "1")
        it "reassocs" $
            executeViaGHCi (reassoc :: HSFunc (String, (Int, Bool)) ((String, Int), Bool)) ("1", (1, True)) `shouldReturn` ((("1", 1), True))
        describe "reassocEither" $ do
            xit "reassocs Left" $
                executeViaGHCi (reassocEither :: HSFunc (Either String (Either Int Bool)) (Either (Either String Int) Bool)) (Left "1") `shouldReturn` (Left (Left "1"))
            xit "reassocs Right (Left)" $
                executeViaGHCi (reassocEither :: HSFunc (Either String (Either Int Bool)) (Either (Either String Int) Bool)) (Right (Left 1)) `shouldReturn` (Left (Right 1))
            xit "reassoc Right (Right)" $
                executeViaGHCi (reassocEither :: HSFunc (Either String (Either Int Bool)) (Either (Either String Int) Bool)) (Right (Right True)) `shouldReturn` (Right True)
    describe "primitive" $ do
        describe "eq" $ do
            it "equal" $
                executeViaGHCi (eq :: HSFunc (String, String) Bool) ("a", "a") `shouldReturn` True
            it "not equal" $
                executeViaGHCi (eq :: HSFunc (String, String) Bool) ("a", "b") `shouldReturn` False
        it "reverses string" $
            executeViaGHCi (reverseString :: HSFunc String String) "abc" `shouldReturn` "cba"
    describe "primitiveconsole" $ pure ()
    describe "primitive extra" $ do
        it "converts int to string" $
            executeViaGHCi (intToString :: HSFunc Int String) 1 `shouldReturn` "1"
        it "concats string" $
            executeViaGHCi (concatString :: HSFunc (String, String) String) ("a", "b") `shouldReturn` "ab"
        it "returns const string" $ do
            executeViaGHCi (constString "a" :: HSFunc () String) () `shouldReturn` "a"
    describe "numeric" $ do
        it "returns const int" $ do
            executeViaGHCi (num 1 :: HSFunc () Int) () `shouldReturn` 1
        it "negates" $ do
            executeViaGHCi (negate' :: HSFunc Int Int) 1 `shouldReturn` (-1)
        it "adds" $ do
            executeViaGHCi (add :: HSFunc (Int, Int) Int) (1, 2) `shouldReturn` 3
        it "mults" $ do
            executeViaGHCi (mult :: HSFunc (Int, Int) Int) (2, 3) `shouldReturn` 6
        it "divs" $ do
            executeViaGHCi (div' :: HSFunc (Int, Int) Int) (4, 2) `shouldReturn` 2
        it "mods" $ do
            executeViaGHCi (mod' :: HSFunc (Int, Int) Int) (5, 2) `shouldReturn` 1
    describe "executeViaGHCi" $ do
        it "returns a string" $
            executeViaGHCi (id :: HSFunc String String) "1" `shouldReturn` "1"
        it "returns an int" $
            executeViaGHCi (id :: HSFunc Int Int) 1 `shouldReturn` 1
        it "returns a bool" $
            executeViaGHCi (id :: HSFunc Bool Bool) True `shouldReturn` True
        it "returns a tuple" $
            executeViaGHCi (id :: HSFunc (String, Int) (String, Int)) ("1", 1) `shouldReturn` ("1", 1)
        describe "Either" $ do
            it "returns a Left" $
                executeViaGHCi (id :: HSFunc (Either String Int) (Either String Int)) (Left "1") `shouldReturn` (Left "1")
            it "returns a Right" $
                executeViaGHCi (id :: HSFunc (Either String Int) (Either String Int)) (Right 1) `shouldReturn` (Right 1)
        describe "Maybe" $ do
            it "returns a Nothing" $
                executeViaGHCi (id :: HSFunc (Maybe Int) (Maybe Int)) Nothing `shouldReturn` Nothing
            it "returns a Just" $
                executeViaGHCi (id :: HSFunc (Maybe Int) (Maybe Int)) (Just 1) `shouldReturn` (Just 1)
            