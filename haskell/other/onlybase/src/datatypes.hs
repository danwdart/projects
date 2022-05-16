import Computer
import           Data.Data
import Player

myComputer ∷ Computer
myComputer = Computer "Dell" "Inspiron"

myPlayer ∷ Player
myPlayer = Player { name = "Bob", position = 23, money = 10000 }

main ∷ IO ()
main = do
    print "Hi!"
    print myComputer
    print $ dataTypeOf myComputer
    print $ dataTypeOf (Just 3 :: Maybe Int)
    print . dataTypeConstrs $ dataTypeOf myComputer
    print . dataTypeConstrs $ dataTypeOf (Nothing :: Maybe ())
    print . dataTypeConstrs $ dataTypeOf (Just 2 :: Maybe Int)
    print $ indexConstr (dataTypeOf (Nothing :: Maybe ())) 1
    print $ indexConstr (dataTypeOf (Nothing :: Maybe ())) 2
    print . isAlgType $ dataTypeOf myComputer
    print $ toConstr myComputer
    print $ toConstr (2 :: Int)
    print $ toConstr (Just 2 :: Maybe Int)
    print . constrType $ toConstr myComputer
    print . constrFields $ toConstr myComputer
    print . constrFields $ toConstr myPlayer
    print (fromConstr (toConstr (Nothing :: Maybe Int)) :: Maybe Int)
    print (fromConstrB (fromConstr (toConstr (1 :: Int))) (toConstr (Just 1 :: Maybe Int)) :: Maybe Int)

    -- etc etc fromConstrM etc
