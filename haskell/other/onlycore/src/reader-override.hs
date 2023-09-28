module Main where

import Control.Monad.Reader
import Env.AbstractExtension as AbstractExtension
import Env.Class             as Class
import Env.Env               as Env
import Env.Extend            as Extend
import Env.ExtendedInstance  as ExtendedInstance
import Env.Instance          as Instance
import Env.WithOrig          as WithOrig

env ∷ Env.Env
env = Env.Env {
    Env.a = "A string",
    Env.b = 42
}

run ∷ ReaderT Env.Env IO ()
run = do
    a' <- asks Env.a
    b' <- asks Env.b
    liftIO . print $ (a', b')


envWithOrig ∷ WithOrig.Env
envWithOrig = WithOrig.Env {
    WithOrig.orig = env,
    WithOrig.c = (1, 2)
}

runWithOrig ∷ ReaderT WithOrig.Env IO ()
runWithOrig = do
    a' <- asks $ Env.a . WithOrig.orig
    b' <- asks $ Env.b . WithOrig.orig
    c' <- asks WithOrig.c
    liftIO . print $ (a', b', c')


envAbstractExtension ∷ AbstractExtension.Env Env.Env
envAbstractExtension = AbstractExtension.Env {
    AbstractExtension.orig = env,
    AbstractExtension.c = (1, 2)
}

runAbstractExtension ∷ ReaderT (AbstractExtension.Env Env.Env) IO ()
runAbstractExtension = do
    a' <- asks $ Env.a . AbstractExtension.orig
    b' <- asks $ Env.b . AbstractExtension.orig
    c' <- asks AbstractExtension.c
    liftIO . print $ (a', b', c')


envExtend ∷ Extend.Env
envExtend = Extend.Env {
    Extend.a = "A string",
    Extend.b = 42,
    Extend.c = (1, 2)
}

runExtend ∷ ReaderT Extend.Env IO ()
runExtend = do
    a' <- asks Extend.a
    b' <- asks Extend.b
    c' <- asks Extend.c
    liftIO . print $ (a', b', c')


envInstance ∷ Instance.Env
envInstance = Instance.Env {
    Instance.a = "A string",
    Instance.b = 42
}

runInstance ∷ (Class.Class clinst) ⇒ ReaderT clinst IO ()
runInstance = do
    a' <- asks Class.a
    b' <- asks Class.b
    liftIO . print $ (a', b')


envExtendedInstance ∷ ExtendedInstance.Env
envExtendedInstance = ExtendedInstance.Env {
    ExtendedInstance.a = "A string",
    ExtendedInstance.b = 42,
    ExtendedInstance.c = (1, 2)
}

runExtendedInstance ∷ ReaderT ExtendedInstance.Env IO ()
runExtendedInstance = do
    a' <- asks Class.a
    b' <- asks Class.b
    c' <- asks ExtendedInstance.c
    liftIO . print $ (a', b', c')

main ∷ IO ()
main = do
    putStrLn "Re-data"
    runReaderT run env
    runReaderT runWithOrig envWithOrig
    runReaderT runExtend envExtend
    putStrLn "Class"
    -- this way we can use the same function if we're only using a couple
    runReaderT runInstance envInstance
    runReaderT runInstance envExtendedInstance
    runReaderT runExtendedInstance envExtendedInstance
