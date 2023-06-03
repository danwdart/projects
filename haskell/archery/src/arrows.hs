-- Shamelessly stolen from the ideas of https://www.youtube.com/watch?v=xZmPuz9m2t0
{-# LANGUAGE Trustworthy, GADTs, LambdaCase, OverloadedLists, OverloadedStrings, QuantifiedConstraints, StandaloneDeriving #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Main where

import Prelude hiding ((.), id)
import Control.Arrow (Kleisli(..))
import Control.Category
import Control.Category.Cartesian
import Control.Monad
import Control.Monad.Fix
import Data.Aeson
import qualified Data.ByteString.Char8 as BS
import qualified Data.ByteString.Lazy.Char8 as BSL
-- import Data.Profunctor
import Data.Render
import Data.String
import Numeric.Natural
import System.Process
import qualified Data.Yaml as Y

-- newtype Diagram a b = Diagram { toGraph :: State Graph InputOutputLinks }

isPalindrome :: (Cartesian cat, Strong cat, Primitive cat) => cat String Bool
isPalindrome = eq . first' reverseString . copy

collatzStep :: forall cat. (Numeric cat, Cartesian cat, Cocartesian cat, Choice cat, Strong cat, Primitive cat) => cat Int Int
collatzStep = unify . (onOdds +++ onEvens) . matchOn isEven where
    onOdds :: cat Int Int
    onOdds = strong add (num 1) . strong mult (num 3)

    onEvens :: cat Int Int
    onEvens = strong div' (num 2)

    isEven :: forall cat. (Numeric cat, Cartesian cat, Strong cat, Primitive cat) => cat Int Bool
    isEven = strong eq (num 0) . mod2

    mod2 :: cat Int Int
    mod2 = strong mod' (num 2)

    matchOn :: (Cartesian cat, Strong cat, Cocartesian cat) => cat a Bool -> cat a (Either a a)
    matchOn predicate = tag . first' predicate . copy

revInputProgram :: (PrimitiveConsole cat, Primitive cat) => cat () ()
revInputProgram = outputString . reverseString . inputString

{-
debugTest :: forall a b cat runnerCat. String -> cat a b -> [(String, runnerCat a b -> a -> b)] -> [a] -> IO ()
debugTest name fn runners cases = do
    putStrLn name
    mapM_ (\(runnerName, runner) -> do
        putStrLn $ runnerName <> ": " <> render (fn :: runnerCat a b)
        putStrLn $ runnerName <> " (Running): " <> show $ traverse (runner fn) cases
        ) runners
-}

main :: IO ()
main = do
    putStrLn "isPalindrome"
    putStrLn $ "HSLamb: " <> render (isPalindrome :: HSLamb String Bool)
    floopyHSL <- runInGHCiParamL isPalindrome "floopy"
    abobaHSL <- runInGHCiParamL isPalindrome "aboba"
    putStrLn $ "HSLamb (GHCi): " <> show floopyHSL
    putStrLn $ "HSLamb (GHCi): " <> show abobaHSL
    putStrLn $ "HSCode: " <> render (isPalindrome :: HSCode String Bool)
    floopyHSC <- runInGHCiParamC isPalindrome "floopy"
    abobaHSC <- runInGHCiParamC isPalindrome "aboba"
    putStrLn $ "HSCode (GHCi): " <> show floopyHSC
    putStrLn $ "HSCode (GHCi): " <> show abobaHSC
    putStrLn $ "JSCode: " <> render (isPalindrome :: JSCode String Bool)
    floopyNode <- runInNode isPalindrome "floopy" :: IO (Maybe Bool)
    abobaNode <- runInNode isPalindrome "aboba" :: IO (Maybe Bool)
    putStrLn $ "JSCode (Node, floopy): " <> show (floopyNode)
    putStrLn $ "JSCode (Node, aboba): " <> show (abobaNode)
    putStrLn $ "PHPCode: " <> render (isPalindrome :: PHPCode String Bool)
    floopyPHP <- runInPHP isPalindrome "floopy" :: IO (Maybe Bool)
    abobaPHP <- runInPHP isPalindrome "aboba" :: IO (Maybe Bool)
    putStrLn $ "PHPCode (PHP, floopy): " <> show (floopyPHP)
    putStrLn $ "PHPCode (PHP, aboba): " <> show (abobaPHP)
    putStrLn $ "FreeFunc: " <> show (isPalindrome :: FreeFunc Prims String Bool)
    putStrLn $ "FreeFunc (JSON encoded): " <> (BSL.unpack $ encode (isPalindrome :: FreeFunc Prims String Bool))
    putStrLn $ "FreeFunc (YAML encoded): " <> (BS.unpack $ Y.encode (isPalindrome :: FreeFunc Prims String Bool))
    putStrLn $ "Execute on (free): " <> show (isPalindrome "floopy")
    putStrLn $ "Execute on (evilolive): " <> show (isPalindrome "aboba")
    putStrLn ""
    putStrLn "collatzStep"
    putStrLn $ "HSLamb: " <> render (collatzStep :: HSLamb Int Int)
    hsl5 <- runInGHCiParamL collatzStep 5
    hsl4 <- runInGHCiParamL collatzStep 4
    putStrLn $ "HSLamb (GHCi, 5): " <> show hsl5
    putStrLn $ "HSLamb (GHCi, 4): " <> show hsl4
    putStrLn $ "HSCode: " <> render (collatzStep :: HSCode Int Int)
    hsc5 <- runInGHCiParamC collatzStep 5
    hsc4 <- runInGHCiParamC collatzStep 4
    putStrLn $ "HSCode (GHCi, 5): " <> show hsc5
    putStrLn $ "HSCode (GHCi, 4): " <> show hsc4
    putStrLn $ "JSCode: " <> render (collatzStep :: JSCode Int Int)
    node5 <- runInNode collatzStep 5
    node4 <- runInNode collatzStep 4
    putStrLn $ "JSCode (Node, 5): " <> show (node5)
    putStrLn $ "JSCode (Node, 4): " <> show (node4)
    putStrLn $ "PHPCode: " <> render (collatzStep :: PHPCode Int Int)
    php5 <- runInPHP collatzStep 5
    php4 <- runInPHP collatzStep 4
    putStrLn $ "PHPCode (PHP, 5): " <> show (php5)
    putStrLn $ "PHPCode (PHP, 4): " <> show (php4)
    putStrLn $ "FreeFunc: " <> show (collatzStep :: FreeFunc Prims Int Int)
    putStrLn $ "FreeFunc (JSON encoded): " <> (BSL.unpack $ encode (collatzStep :: FreeFunc Prims Int Int))
    putStrLn $ "FreeFunc (YAML encoded): " <> (BS.unpack $ Y.encode (collatzStep :: FreeFunc Prims Int Int))
    putStrLn $ "Execute on 3: " <> show (collatzStep 3)
    putStrLn $ "Execute on 4: " <> show (collatzStep 4)
    putStrLn ""
    putStrLn "revInputProgram" -- @TODO use a different type?
    -- putStrLn $ "HSLamb: " <> render (revInputProgram :: HSLamb () ()) -- @TODO fix
    -- runInGHCiParamL revInputProgram ()
    putStrLn $ "HSCode: " <> render (revInputProgram :: HSCode () ())
    -- runInGHCiParamC revInputProgram ()
    putStrLn $ "JSCode: " <> render (revInputProgram :: JSCode () ()) -- we ain't running that as we're in no browser
    putStrLn $ "PHPCode: " <> render (revInputProgram :: PHPCode () ())
    -- runInPHP revInputProgram ()
    -- putStrLn $ "FreeFunc: " <> show (revInputProgram :: (PrimitiveConsole (FreeFunc p), Primitive (FreeFunc p)) => FreeFunc p () ())
    -- putStrLn $ "FreeFunc (JSON encoded): " <> (BSL.unpack $ encode (revInputProgram :: FreeFunc p () ()))
    putStrLn $ "Executing using runKleisli."
    runKleisli revInputProgram ()