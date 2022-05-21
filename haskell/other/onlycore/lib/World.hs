{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module World where

import           Control.Monad.State
import           GHC.IO

-- World
data World = World deriving Show

putStrLnW ∷ String → World → World
putStrLnW s !w = unsafePerformIO $ putStrLn s >> pure w

readLineW ∷ World → (String, World)
readLineW !w = unsafePerformIO $ getLine >>= (\s -> pure (s, w))

-- WorldT
type WorldT a = World → (a, World)

readLineT ∷ WorldT String
readLineT = readLineW

putStrLnT ∷ String → WorldT ()
putStrLnT s w = ((), putStrLnW s w)

infixl 1 >>>=
(>>>=) ∷ WorldT a → (a → WorldT b) → WorldT b
wt >>>= f = uncurry f . wt

infixl 1 >>>
(>>>) ∷ WorldT a → WorldT b → WorldT b
wt >>> wt2 = wt >>>= const wt2

-- WorldM
newtype WorldM a = WorldM { asT :: WorldT a } deriving (Functor)

instance Applicative WorldM where
    pure x = WorldM (x,)
    wtf <*> wt = WorldM (asT wtf >>>= \f ->
        asT wt >>>= \x ->
        asT . pure $ f x)

instance Monad WorldM where
    wt >>= f = WorldM (asT wt >>>= asT . f)

putStrLnM ∷ String → WorldM ()
putStrLnM = WorldM . putStrLnT

readLineM ∷ WorldM String
readLineM = WorldM readLineT

-- State
type WorldS = State World

readLineS ∷ WorldS String
readLineS = state readLineW

putStrLnS ∷ String → WorldS ()
putStrLnS = modify . putStrLnW
