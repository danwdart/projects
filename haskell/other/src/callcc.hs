import Control.Monad.Cont

c :: Cont r Int
c = cont ($ 34)

run :: IO ()
run = runCont c print

-- runCC = 

main :: IO ()
main = run