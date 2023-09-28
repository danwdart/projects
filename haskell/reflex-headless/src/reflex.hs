import Control.Monad.IO.Class
import Reflex
import Reflex.Host.Headless

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
    _ <- performEvent ((liftIO . aExit $ ()) <$ e8)
    -- Now todo experiment on behaviours etc
    pure eExit -- When do we exit?
