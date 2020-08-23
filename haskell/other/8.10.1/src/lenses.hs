{-# LANGUAGE TemplateHaskell #-}

-- import Control.Monad
import           Control.Lens

a :: (Int, Int, Int)
a = (1, 2, 3)

data MyStruct = MyStruct {
    _name    :: String,
    _age     :: Int,
    _friends :: [MyStruct]
} deriving (Show)

makeLenses ''MyStruct

bob :: MyStruct
bob = MyStruct {
    _name = "Bob",
    _age = 27,
    _friends = [
        MyStruct {
            _name = "Jim",
            _age = 27,
            _friends = []
        }
    ]
}

main :: IO ()
main = do
    print a
    print $ a^._2
    print $ set _2 (42 :: Int) a
    print $ _2 .~ (42 :: Int) $ a
    print $ a^._2
    print $ "Bob"^.to length
    print $ view _2 ((1, 2) :: (Int, Int))
    print $ (((1,0),(2,"Two"),(3,0)) :: ((Int, Int), (Int, String), (Int, Int)) )^._2._2.to length
    print $ bob^.name ++ show (bob^.age) ++ bob^.friends.ix 0.name
