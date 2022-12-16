module Main where

import OOP

main :: IO ()
main = do
    putStrLn "-- MyClass --"

    let myObject :: MyClass
        myObject = new (1 :: Int)
    performAnActionEvilly myObject

    let myObject2 :: MyClass
        myObject2 = updateVariable (2 :: Int) myObject
    performAnActionEvilly myObject2


    putStrLn "-- MyOtherClass --"

    let myOtherObject :: MyOtherClass
        myOtherObject = new "Mwahaha"
    printA myOtherObject

    let myOtherObject2 = updateVariable "Evil" myOtherObject
    printA myOtherObject2


    putStrLn "-- EvenMoreEvil --"

    let evilness :: EvenMoreEvil
        evilness = new ()

    s evilness
    evilness2 <- mwahaha evilness
    s evilness2


    putStrLn "-- TupleOfInputs --"

    let myTupleObject :: TupleOfInputs Int Int
        myTupleObject = new ((1, 2) :: (Int, Int))

    printThem myTupleObject

    let myTupleObject2 :: TupleOfInputs Int Int
        myTupleObject2 = updateVariable ((2, 3) :: (Int, Int)) myTupleObject

    printThem myTupleObject2


    putStrLn "-- StaticSumType --"

    let myStaticSumTypeInt :: StaticSumType
        myStaticSumTypeInt = new (1 :: Int)

    print myStaticSumTypeInt

    let myStaticSumTypeInt2 :: StaticSumType
        myStaticSumTypeInt2 = updateVariable (2 :: Int) myStaticSumTypeInt

    print myStaticSumTypeInt2


    let myStaticSumTypeString :: StaticSumType
        myStaticSumTypeString = new "Hi"

    print myStaticSumTypeString

    let myStaticSumTypeString2 :: StaticSumType
        myStaticSumTypeString2 = updateVariable "Hi" myStaticSumTypeString

    print myStaticSumTypeString2


    putStrLn "-- NastySideEffects --"

    myNastySideEffects <- newEvil () :: IO NastySideEffects

    evil myNastySideEffects

    myNastySideEffects' <- evil2 myNastySideEffects

    evil myNastySideEffects'

    myNastySideEffects2 <- updateVariableEvil () myNastySideEffects

    evil myNastySideEffects2

    myNastySideEffects2' <- evil2 myNastySideEffects2

    evil myNastySideEffects2'


    putStrLn "-- WorstEvil --"

    myWorstEvil <- constructor ("Hello", "World") :: IO WorstEvil

    displayAll (undefined :: String) (undefined :: String) myWorstEvil

    updateVars ("Goodbye", "Evilness") myWorstEvil

    displayAll (undefined :: String) (undefined :: String) myWorstEvil
