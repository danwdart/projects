import Control.Monad.Reader

myReader :: (Num a, MonadReader a m) => m a
myReader = reader (+1)

run :: Int
run = runReader myReader 11

main :: IO ()
main = print run