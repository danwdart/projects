-- Cont demo

import Control.Monad.Cont

-- It's like a JS callback that can interrupt stuff

myCont :: Cont Int Int
myCont = cont ($ 34)

myContT :: ContT r m Int
myContT = ContT ($ 34)

myCB :: Int -> Int
myCB = (*2)

myCBT :: Int -> Maybe Int
myCBT = Just

result :: Int
result = runCont myCont myCB

resultT = runCont myContT myCBT

main :: IO ()
main = do
    print result
    print resultT