-- Shamelessly stolen from the ideas of https://www.youtube.com/watch?v=xZmPuz9m2t0
{-# LANGUAGE Trustworthy, GADTs, LambdaCase, OverloadedLists, OverloadedStrings, QuantifiedConstraints, StandaloneDeriving #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Main where

import Prelude hiding ((.), id)
import Control.Arrow (Kleisli(..))
import Data.Aeson
import qualified Data.ByteString.Char8 as BS
import qualified Data.ByteString.Lazy.Char8 as BSL
-- import Data.Profunctor
import Control.Category.Execute.Haskell
import Control.Category.Execute.JSON
import Data.Code.Haskell.Func
import Data.Code.Haskell.Lamb
import Data.Code.JS.Lamb
import Data.Code.PHP.Lamb
import Data.Function.Free.Abstract
import Data.Function.IsPalindrome
import Data.Function.CollatzStep
import Data.Function.ReverseInput
import Data.Primitive.Prims
import Data.Render
import qualified Data.Yaml as Y

-- newtype Diagram a b = Diagram { toGraph :: State Graph InputOutputLinks }


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
    {-}
    let functions :: [(String, Fn)]
        functions = [
            ("isPalindrome", Fn isPalindrome [("floopy", False), ("aboba", True)]),
            ("collatzStep", Fn collatzStep [(3, 10), (4, 2), (5, 16)])
            ]
    -}
    do
        let fnName :: String
            fnName = "isPalindrome"

            examples :: [(String, Bool)]
            examples = [
                ("floopy", False),
                ("aboba", True)
                ]

        putStrLn fnName

        do
            let catName :: String
                catName = "HSLamb"
                fn :: HSLamb String Bool
                fn = isPalindrome

            putStrLn $ catName <> ": " <> render fn
            exampleAnswers <- mapM (executeViaGHCi fn) (fst <$> examples)
            putStrLn $ catName <> " (GHCi): " <> show (exampleAnswers :: [Bool])
        do
            let catName :: String
                catName = "HSFunc"
                fn :: HSFunc String Bool
                fn = isPalindrome

            putStrLn $ catName <> ": " <> render fn
            exampleAnswers <- mapM (executeViaGHCi fn) (fst <$> examples)
            putStrLn $ catName <> " (GHCi): " <> show (exampleAnswers :: [Bool])
        



    putStrLn $ "JSLamb: " <> render (isPalindrome :: JSLamb String Bool)
    floopyNode <- executeViaJSON (isPalindrome :: JSLamb String Bool) "floopy" :: IO (Maybe Bool)
    abobaNode <- executeViaJSON (isPalindrome :: JSLamb String Bool) "aboba" :: IO (Maybe Bool)
    putStrLn $ "JSLamb (Node, floopy): " <> show (floopyNode)
    putStrLn $ "JSLamb (Node, aboba): " <> show (abobaNode)
    putStrLn $ "PHPLamb: " <> render (isPalindrome :: PHPLamb String Bool)
    floopyPHP <- executeViaJSON (isPalindrome :: PHPLamb String Bool) "floopy" :: IO (Maybe Bool)
    abobaPHP <- executeViaJSON (isPalindrome :: PHPLamb String Bool) "aboba" :: IO (Maybe Bool)
    putStrLn $ "PHPLamb (PHP, floopy): " <> show (floopyPHP)
    putStrLn $ "PHPLamb (PHP, aboba): " <> show (abobaPHP)
    putStrLn $ "FreeFunc: " <> show (isPalindrome :: FreeFunc Prims String Bool)
    putStrLn $ "FreeFunc (JSON encoded): " <> (BSL.unpack $ encode (isPalindrome :: FreeFunc Prims String Bool))
    putStrLn $ "FreeFunc (YAML encoded): " <> (BS.unpack $ Y.encode (isPalindrome :: FreeFunc Prims String Bool))
    putStrLn $ "Execute on (free): " <> show (isPalindrome "floopy")
    putStrLn $ "Execute on (evilolive): " <> show (isPalindrome "aboba")

    putStrLn ""
    putStrLn "collatzStep"
    putStrLn $ "HSLamb: " <> render (collatzStep :: HSLamb Int Int)
    hsl5 <- executeViaGHCi (collatzStep :: HSLamb Int Int) 5
    hsl4 <- executeViaGHCi (collatzStep :: HSLamb Int Int) 4
    putStrLn $ "HSLamb (GHCi, 5): " <> show hsl5
    putStrLn $ "HSLamb (GHCi, 4): " <> show hsl4
    putStrLn $ "HSFunc: " <> render (collatzStep :: HSFunc Int Int)
    hsc5 <- executeViaGHCi (collatzStep :: HSFunc Int Int) 5
    hsc4 <- executeViaGHCi (collatzStep :: HSFunc Int Int) 4
    putStrLn $ "HSFunc (GHCi, 5): " <> show hsc5
    putStrLn $ "HSFunc (GHCi, 4): " <> show hsc4
    putStrLn $ "JSLamb: " <> render (collatzStep :: JSLamb Int Int)
    node5 <- executeViaJSON (collatzStep :: JSLamb Int Int) 5
    node4 <- executeViaJSON (collatzStep :: JSLamb Int Int) 4
    putStrLn $ "JSLamb (Node, 5): " <> show (node5)
    putStrLn $ "JSLamb (Node, 4): " <> show (node4)
    putStrLn $ "PHPLamb: " <> render (collatzStep :: PHPLamb Int Int)
    php5 <- executeViaJSON (collatzStep :: PHPLamb Int Int) 5
    php4 <- executeViaJSON (collatzStep :: PHPLamb Int Int) 4
    putStrLn $ "PHPLamb (PHP, 5): " <> show (php5)
    putStrLn $ "PHPLamb (PHP, 4): " <> show (php4)
    putStrLn $ "FreeFunc: " <> show (collatzStep :: FreeFunc Prims Int Int)
    putStrLn $ "FreeFunc (JSON encoded): " <> (BSL.unpack $ encode (collatzStep :: FreeFunc Prims Int Int))
    putStrLn $ "FreeFunc (YAML encoded): " <> (BS.unpack $ Y.encode (collatzStep :: FreeFunc Prims Int Int))
    putStrLn $ "Execute on 3: " <> show (collatzStep 3)
    putStrLn $ "Execute on 4: " <> show (collatzStep 4)
    putStrLn ""


    putStrLn "revInputProgram" -- @TODO use a different type?
    -- putStrLn $ "HSLamb: " <> render (revInputProgram :: HSLamb () ()) -- @TODO fix
    -- executeViaGHCi revInputProgram ()
    putStrLn $ "HSFunc: " <> render (revInputProgram :: HSFunc () ())
    -- executeViaGHCi revInputProgram ()
    putStrLn $ "JSLamb: " <> render (revInputProgram :: JSLamb () ()) -- we ain't running that as we're in no browser
    putStrLn $ "PHPLamb: " <> render (revInputProgram :: PHPLamb () ())
    -- runInPHP revInputProgram ()
    -- putStrLn $ "FreeFunc: " <> show (revInputProgram :: (PrimitiveConsole (FreeFunc p), Primitive (FreeFunc p)) => FreeFunc p () ())
    -- putStrLn $ "FreeFunc (JSON encoded): " <> (BSL.unpack $ encode (revInputProgram :: FreeFunc p () ()))
    putStrLn $ "Executing using runKleisli."
    runKleisli revInputProgram ()