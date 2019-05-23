import Control.Monad (liftM)

main :: IO ()
main = interact $ liftM succ
