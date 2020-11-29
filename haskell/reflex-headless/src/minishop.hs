{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilies     #-}
{-# LANGUAGE UnicodeSyntax    #-}

import           Control.Monad.IO.Class
import           Reflex
import           Reflex.Host.Headless

import           System.Console.ANSI

putStrLnL ∷ MonadIO m ⇒ String → m ()
putStrLnL = liftIO . putStrLn

getCharL ∷ MonadIO m ⇒ m Char
getCharL = liftIO getChar

getLineL ∷ MonadIO m ⇒ m String
getLineL = liftIO getLine

{-
readyEvent :: MonadIO m => m ()
readyEvent = putStrLnL "Ready."
-}

showit ∷ MonadIO m ⇒ Char → m ()
showit = putStrLnL . (: [])

echo ∷ MonadIO m ⇒ String → m ()
echo = putStrLnL . ("You said: " ++)


exitWith ∷ MonadIO m ⇒ (() → IO a) → m a
exitWith aExit = liftIO . aExit $ ()

app ∷ (MonadHeadlessApp t m) ⇒ m (Event t ())
app = newTriggerEvent >>=
    \(e, a) ->
    getPostBuild >>=
    performEvent . (drawMenu AppState <$) >>=
    performEvent . (getCharL <$) >>=
    performEvent . (showit <$>) >>=
    performEvent . (getLineL <$) >>=
    performEvent . (echo <$>) >>=
    performEvent . (exitWith a <$) >>
    return e

data AppState = AppState

drawMenu ∷ MonadIO m ⇒ AppState → m ()
drawMenu _ = liftIO $ do
    clearScreen
    putStrLn "Mini Shop - Not Logged In (L/Q)"

main ∷ IO ()
main = runHeadlessApp app
