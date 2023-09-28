{-# OPTIONS_GHC -Wno-partial-fields #-}

module OOP where

import Data.IORef

-- Mwahahahaha!

class Instantiable params type' where
    new :: params → type'
    updateVariable :: params → type' → type'

data MyClass = MyClass {
    localVariable         :: Int,
    performAnActionEvilly :: IO ()
}

instance Instantiable Int MyClass where
    new x = MyClass {
        localVariable = x,
        performAnActionEvilly = print x
    }
    updateVariable y obj = obj { localVariable = y }

data MyOtherClass = MyOtherClass {
    a      :: String,
    printA :: IO ()
}

instance Instantiable String MyOtherClass where
    new x = MyOtherClass {
        a = x,
        printA = print x
    }
    updateVariable y obj = obj { a = y }

data EvenMoreEvil = EvenMoreEvil {
    s       :: IO (),
    mwahaha :: IO EvenMoreEvil
}

instance Instantiable () EvenMoreEvil where
    new () = EvenMoreEvil {
        s = print "Mwahahaha",
        mwahaha = pure (new ())
    }
    updateVariable _ obj = obj

data TupleOfInputs a b = TupleOfInputs {
    inputA    :: a,
    inputB    :: b,
    printThem :: IO ()
}

instance (Show a, Show b) ⇒ Instantiable (a, b) (TupleOfInputs a b) where
    new (a, b) = TupleOfInputs {
        inputA = a,
        inputB = b,
        printThem = do
            print a
            print b
    }
    updateVariable (a, b) obj = obj {
        inputA = a,
        inputB = b
    }

data StaticSumType = AnInt {
    anInt :: Int
} | AString {
    aString :: String
} deriving Show

instance Instantiable Int StaticSumType where
    new = AnInt
    updateVariable newInt theSumType = case theSumType of
        AnInt _ -> theSumType { anInt = newInt }
        x       -> x -- redundant?

instance Instantiable String StaticSumType where
    new = AString
    updateVariable newString theSumType = case theSumType of
        AString _ -> theSumType { aString = newString }
        x         -> x -- redundant?

class InstantiableWithNastySideEffects params type' where
    newEvil :: params → IO type'
    updateVariableEvil :: params → type' → IO type'


data NastySideEffects = NastySideEffects {
    evil  :: IO (),
    evil2 :: IO NastySideEffects
}

instance Show NastySideEffects where
    show _ = "Error: too evil to show"

instance InstantiableWithNastySideEffects () NastySideEffects where
    newEvil () = do
        putStrLn "Creating the evil being"
        pure NastySideEffects {
            evil = putStrLn "The evilest function known to humankind",
            evil2 = do
                putStrLn "Making even more evil"
                newEvil () :: IO NastySideEffects
        }
    updateVariableEvil x evilObject = do
        putStrLn "Updating the variable!"
        print x
        putStrLn "Before"
        print evilObject
        let newEvil' ∷ NastySideEffects
            newEvil' = evilObject { evil = putStrLn "It got updated, overridden if you will" }
        putStrLn "After"
        print newEvil'
        pure newEvil'

class TheWorstKindOfEvil a b obj where
    constructor :: (a, b) → IO obj -- no curry for you, I'm too evil!
    updateVars :: (a, b) → obj → IO ()
    displayAll :: a → b → obj → IO () -- TODO find out how to omit these

data WorstEvil = WorstEvil {
    worstA :: IORef String,
    worstB :: IORef String
}

instance TheWorstKindOfEvil String String WorstEvil where
    constructor (a, b) = do
        a' <- newIORef a
        b' <- newIORef b
        pure $ WorstEvil {
            worstA = a',
            worstB = b'
        }

    updateVars (newA, newB) evil = do
        writeIORef (worstA evil) newA
        writeIORef (worstB evil) newB

    displayAll _ _ evil = do
        a' <- readIORef (worstA evil)
        b' <- readIORef (worstB evil)
        print (a', b')
