-- Cont demo
import Control.Monad.Cont

-- It's like a JS callback that can interrupt stuff
main :: IO ()
main = do
    print $ runCont (cont ($ (34 :: Int))) (*2)
    print $ runCont (ContT ($ (34 :: Int))) Just