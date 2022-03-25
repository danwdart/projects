{-# LANGUAGE BangPatterns  #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE TupleSections #-}
{-# LANGUAGE UnicodeSyntax #-}

module Main where
import           Control.Monad.State
import           GHC.IO

-- IO

askName ∷ IO ()
askName = do
    putStrLn "[IO] What is your name?"
    name <- getLine
    putStrLn $ "[IO] Hello, " <> name

-- World

data World = World deriving Show

putStrLnW ∷ String → World → World
putStrLnW s !w = unsafePerformIO $ putStrLn s >> pure w

readLineW ∷ World → (String, World)
readLineW !w = unsafePerformIO $ getLine >>= (\s -> pure (s, w))

askNameW ∷ World → World
askNameW w1 = w4
    where w2 = putStrLnW "[W] What is your name?" w1
          (name, w3) = readLineW w2
          w4 = putStrLnW ("[W] Hello, " <> name) w3

branchW ∷ World → (World, World)
branchW w = (putStrLnW "Good" w, putStrLnW "Bad" w)

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

askNameT ∷ WorldT ()
askNameT = putStrLnT "[T] What is your name?" >>>
    readLineT >>>= \name ->
    putStrLnT $ "[T] Hello, " <> name

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

askNameM ∷ WorldM ()
askNameM = do
    putStrLnM "[M] What is your name?"
    name <- readLineM
    putStrLnM $ "[M] Hello, " <> name

-- State
type WorldS = State World

readLineS ∷ WorldS String
readLineS = state readLineW

putStrLnS ∷ String → WorldS ()
putStrLnS = modify . putStrLnW

askNameS ∷ WorldS ()
askNameS = do
    putStrLnS "[S] What is your name?"
    name <- readLineS
    putStrLnS $ "[S] Hello, " <> name

main ∷ IO ()
main = do
    askName
    print $ askNameW World
    print $ askNameT World
    print $ asT askNameM World
    print $ runState askNameS World
    pure ()
