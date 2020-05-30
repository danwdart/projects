{-# LANGUAGE UnicodeSyntax #-}
import           Control.Concurrent.Async
import           Control.Monad
import           Control.Monad.IO.Class
import           Reflex
import           Reflex.Host.Class
import           Reflex.Host.Headless
import           Reflex.PerformEvent.Base
import           Reflex.TriggerEvent.Base

main ∷ IO ()
main = runHeadlessApp $ do
    epb <- getPostBuild
     -- event triggered when function triggered
    (eExit, aExit) <- newTriggerEvent
     -- run action (inside event of performable) when event triggered
    e2 <- performEvent ((liftIO . putStrLn $ "Ready.") <$ epb)
    e4 <- performEvent (liftIO getChar <$ e2)
    e6 <- performEvent (liftIO . putStrLn . (: []) <$> e4)
    e7 <- performEvent (liftIO getLine <$ e6)
    e8 <- performEvent (liftIO . putStrLn . ("You said: " ++) <$> e7)
    e9 <- performEvent ((liftIO . aExit $ ()) <$ e8)
    -- Now todo experiment on behaviours etc
    return eExit -- When do we exit?