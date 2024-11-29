module Main (main) where

import Control.Monad (void)
import Sound.Pulse
import Sound.Pulse.Context
import Sound.Pulse.Mainloop.Simple
import Sound.Pulse.Serverinfo
import Sound.Pulse.Subscribe

main ∷ IO ()
main = do
    ml <- getMainloopImpl
    ctx <- getContext ml "HaskellSound"
    print ctx
    void $ subscribeEvents ctx [SubscriptionMaskAll] (\a b -> print a >> print b)
    connRet <- connectContext ctx (Just "localhost") [ContextNoflags]
    print connRet
    runPulse_ ctx $ pure ()
    getServerInfo ctx print
    ret <- doLoop ml
    print ret
