{-# LANGUAGE ScopedTypeVariables #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main (main) where

import Control.Monad.IO.Class
import Data.Functor.Contravariant
import Data.StateVar

type LiftedGettableStateVar m = m

makeLiftedGettableStateVar ∷ m a → LiftedGettableStateVar m a
makeLiftedGettableStateVar = id

-- instance forall m a. MonadIO m => HasGetter (LiftedGettableStateVar m a) a where
--     get = id

newtype LiftedSettableStateVar m a = LiftedSettableStateVar (a → m ())

instance Contravariant (LiftedSettableStateVar m) where
    contramap c (LiftedSettableStateVar f) = LiftedSettableStateVar (f . c)

-- instance HasSetter (LiftedSettableStateVar m a) a where
--     LiftedSettableStateVar f $= x = f x

makeLiftedSettableStateVar ∷ (a → m ()) → LiftedSettableStateVar m a
makeLiftedSettableStateVar = LiftedSettableStateVar

data LiftedStateVar m a = LiftedStateVar (m a) (a → m ())

-- instance HasGetter (LiftedStateVar m a) a where
--     get (LiftedStateVar getter _) = getter

-- instance HasSetter (LiftedStateVar m a) a where
--     ($=) (LiftedStateVar _ setter) = setter

-- instance HasUpdate (LiftedStateVar m a) a a where

svWriteFile ∷ FilePath → SettableStateVar String
svWriteFile fileName = SettableStateVar (writeFile fileName)

liftedSvWriteFile ∷ MonadIO m ⇒ FilePath → LiftedSettableStateVar m String -- generic
liftedSvWriteFile fileName = makeLiftedSettableStateVar (liftIO . writeFile fileName)

-- genericLiftedSvWriteFile :: HasSetter s String => s String
-- genericLiftedSvWriteFile = _ . liftIO . writeFile


svReadFile ∷ FilePath → GettableStateVar String
svReadFile = makeLiftedGettableStateVar readFile

liftedSvReadFile ∷ MonadIO m ⇒ FilePath → LiftedGettableStateVar m String -- generic
liftedSvReadFile = makeLiftedGettableStateVar . liftIO . readFile

{-}
genericLiftedSvReadFile :: (HasGetter _ String, MonadIO m) => m String
genericLiftedSvReadFile = _ . liftIO . readFile
-}

svRWFile ∷ FilePath → StateVar String
svRWFile fileName = StateVar (readFile fileName) (writeFile fileName)

liftedSvRWFile ∷ MonadIO m ⇒ FilePath → LiftedStateVar m String
liftedSvRWFile fileName = LiftedStateVar (liftIO $ readFile fileName) (liftIO . writeFile fileName)

{-}
genericSvRWFile :: (HasGetter s String, HasSetter s String) => s _
genericSvRWFile = _ . _ (liftIO . readFile) (liftIO . writeFile)
-}

writeBob ∷ SettableStateVar String
writeBob = svWriteFile "bob.txt"

rwBob ∷ StateVar String
rwBob = svRWFile "bob.txt"

readBob ∷ GettableStateVar String
readBob = svReadFile "bob.txt"

main ∷ IO ()
main = do
    putStrLn "Writing..."
    writeBob $= "Hi!"

    -- let writeBobLifted = liftedSvWriteFile "bob2.txt" :: LiftedSettableStateVar IO String
    -- liftIO $ writeBobLifted $= "Hi!"

    -- let writeBobGeneric = genericLiftedSvWriteFile "bob3.txt"
    -- liftIO $ writeBobGeneric $= "Hi!"

    putStrLn "Modifying..."
    rwBob $~ (<> " I am not \"BOB\"!") -- dies because locked

    -- let rwBobLifted = liftedSvRWFile "bob2.txt" :: LiftedStateVar IO String
    -- liftIO $ rwBobLifted $~ (<> " I am not \"BOB\"!")

    -- let rwBobGeneric = genericSvRWFile "bob3.txt"
    -- liftIO $ rwBobGeneric $~ (<> " I am not \"BOB\"!")

    putStrLn "Getting..."
    bob <- get readBob
    print bob

    -- let readBobLifted = liftedSvReadFile "bob2.txt" :: LiftedGettableStateVar String
    -- bobLifted <- get readBobLifted
    -- print bobLifted

    -- let readBobGeneric = genericLiftedSvReadFile "bob3.txt"
    -- bobGeneric <- get readBobGeneric
    -- print bobGeneric
