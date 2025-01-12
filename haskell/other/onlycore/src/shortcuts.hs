module Main where

import Control.Monad.Cont
import Control.Monad.Except
import Control.Monad.IO.Class
import Control.Monad.Trans.Maybe

shortcutMaybe ∷ Maybe String
shortcutMaybe = do
    a <- Just "Hello, "
    c <- Just "World!"
    d <- Nothing
    pure $ a <> c <> d

shortcutMaybeFail ∷ MonadFail m ⇒ m String
shortcutMaybeFail = do
    let a = "Hello, "
    let c = "World!"
    d <- fail "Nah"
    pure $ a <> c <> d

shortcutMaybeT ∷ MaybeT IO String
shortcutMaybeT = do
    a <- hoistMaybe $ Just "Hello, "
    let b = Just "World!"
    c <- hoistMaybe b
    d <- hoistMaybe Nothing
    liftIO . putStrLn $ "You shouldn't see this."
    pure $ a <> c <> d

shortcutMaybeTFail ∷ (MonadFail m, MonadIO m) ⇒ m String
shortcutMaybeTFail = do
    let a = "Hello, "
    let c = "World!"
    d <- fail "Nope."
    liftIO . putStrLn $ "You shouldn't see this."
    pure $ a <> c <> d

shortcutEither ∷ Either String Int
shortcutEither = do
    a <- Right 12
    c <- Right 24
    d <- Left "Nah"
    pure $ a + c + d

shortcutEitherError ∷ (MonadError String m) ⇒ m Int
shortcutEitherError = do
    let a = 12
    let c = 24
    d <- throwError "Nah"
    pure $ a + c + d

shortcutExcept ∷ Except String Int
shortcutExcept = do
    a <- liftEither $ Right 12
    c <- liftEither $ Right 24
    d <- liftEither <$> Left $ "Nah"
    pure $ a + c + d

shortcutExceptError ∷ (MonadError String m) ⇒ m Int
shortcutExceptError = do
    let a = 12
    let c = 24
    d <- throwError "Nah"
    pure $ a + c + d

shortcutExceptT ∷ ExceptT String IO Int
shortcutExceptT = do
    a <- liftEither $ Right 12
    c <- liftEither $ pure 24
    d <- liftEither <$> Left $ "Nah"
    liftIO . putStrLn $ "You shouldn't see this."
    pure $ a + c + d

shortcutExceptTError ∷ (MonadError String m, MonadIO m) ⇒ m Int
shortcutExceptTError = do
    a <- liftEither $ Right 12
    c <- liftEither $ pure 24
    d <- liftEither <$> Left $ "Nah"
    liftIO . putStrLn $ "You shouldn't see this."
    pure $ a + c + d

shortcutCont ∷ Cont String String
shortcutCont = callCC $ \k -> do
    let a = 'a'
    let c = 'c'
    d <- k "How dare you!"
    pure [a, c, d]

shortcutContMC ∷ MonadCont m ⇒ m String
shortcutContMC = callCC $ \k -> do
    let a = 'a'
    let c = 'c'
    d <- k "How dare you!"
    pure [a, c, d]

shortcutContT ∷ ContT String IO String
shortcutContT = callCC $ \k -> do
    let a = 'a'
    let c = 'c'
    d <- k "How dare you!"
    liftIO . putStrLn $ "You shouldn't see this."
    pure [a, c, d]

shortcutContTMC ∷ (MonadCont m, MonadIO m) ⇒ m String
shortcutContTMC = callCC $ \k -> do
    let a = 'a'
    let c = 'c'
    d <- k "How dare you!"
    liftIO . putStrLn $ "You shouldn't see this."
    pure [a, c, d]

main ∷ IO ()
main = do
    putStrLn "Maybe"
    print shortcutMaybe
    putStrLn "Maybe by MonadFail"
    print (shortcutMaybeFail :: Maybe String) -- or Fail passes through
    putStrLn "MaybeT"
    print =<< runMaybeT shortcutMaybeT
    putStrLn "MaybeT by MonadFail"
    print =<< runMaybeT shortcutMaybeTFail
    putStrLn "Either"
    print shortcutEither
    putStrLn "Either by MonadError"
    print (shortcutEitherError :: Either String Int)
    putStrLn "Except"
    print $ runExcept shortcutExcept
    putStrLn "Except by MonadError"
    print $ runExcept (shortcutExceptError :: Except String Int)
    putStrLn "ExceptT"
    print =<< runExceptT shortcutExceptT
    putStrLn "ExceptT by MonadError"
    print =<< runExceptT shortcutExceptTError
    putStrLn "Cont"
    print $ evalCont shortcutCont
    putStrLn "Cont by MonadCont"
    print $ evalCont shortcutContMC
    putStrLn "ContT"
    print =<< evalContT shortcutContT
    putStrLn "ContT by MonadCont"
    print =<< evalContT shortcutContTMC
