import Control.Monad.Tardis

main :: IO ()
main = print $ flip runTardis ("I'm The Doctor.", "I'm The Doctor.") $ do
    y <- getPast
    sendFuture "2073"
    sendPast "1973"
    x <- getFuture
    return (x, y)