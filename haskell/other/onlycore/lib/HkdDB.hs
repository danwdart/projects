{-# LANGUAGE UndecidableInstances #-}

module HkdDB where

import Control.Monad.Reader
import Data.Functor.Const
import Data.Functor.Identity

import Language.Haskell.TH

data Entity = Entity {
    name :: String,
    quantity :: Int
} deriving (Show, Eq)

newtype HKDEntity f = HKDEntity {
    entity :: f Entity
}

deriving instance (Show (f Entity)) => Show (HKDEntity f)
deriving instance (Eq (f Entity)) => Eq (HKDEntity f)

-- >>> Entity "Bob" 123
-- Entity {name = "Bob", quantity = 123}
--

-- >>> HKDEntity (Identity (Entity "Bob" 123))
-- HKDEntity {entity = Identity (Entity {name = "Bob", quantity = 123})}
--

-- >>> HKDEntity (Just (Entity "Bob" 123))
-- HKDEntity {entity = Just (Entity {name = "Bob", quantity = 123})}
--

data AlreadyHKDEntity f = AlreadyHKDEntity {
    aName :: f String,
    aQuantity :: f Int
}

deriving instance (Show (f String), Show (f Int)) => Show (AlreadyHKDEntity f)
deriving instance (Eq (f String), Eq (f Int)) => Eq (AlreadyHKDEntity f)

-- >>> AlreadyHKDEntity (Just "Bob") (Just 42)
-- AlreadyHKDEntity {aName = Just "Bob", aQuantity = Just 42}
--

-- >>> AlreadyHKDEntity (Identity "Bob") (Identity 42)
-- AlreadyHKDEntity {aName = Identity "Bob", aQuantity = Identity 42}
--

-- >>> AlreadyHKDEntity (Const "Name") (Const "Quantity")
-- AlreadyHKDEntity {aName = Const "Name", aQuantity = Const "Quantity"}
--

-- >>> AlreadyHKDEntity (pure "Name") (pure 42) :: AlreadyHKDEntity IO
-- <interactive>:2277:2-64: error:
--     • No instance for (Show (IO String)) arising from a use of ‘print’
--     • In a stmt of an interactive GHCi command: print it
--

data JoinedTableData = JoinedTableData {
    joinedColumn1 :: String,
    joinedColumn2 :: Bool
} deriving (Show, Eq)

data WithJoinData a = WithJoinData {
    orig :: a,
    columnB :: String,
    rowsC :: [JoinedTableData]
}

-- GADT?
data ColWithType = forall a. ColWithType {
    valType :: Name,
    val :: a
}

-- TH?
data ColDefinition = ColDefinition {
    colName :: String,
    colType :: Name
}

data WithGeneralisedExtraCols a = WithGeneralisedExtraCols {
    wgecOrig :: a,
    cols :: [ColWithType]
}

type Row = [ColWithType]

data WithGeneralisedExtraRows a = WithGeneralisedExtraRows {
    wgerOrig :: a,
    rows :: [Row]
}

data WithJoinOne tableType joinTable = WithJoinOne {
    wjoTableData :: tableType,
    wjoJoinData :: joinTable
}

data WithJoinMulti tableType joinType = WithJoinMulti {
    wjmTableData :: tableType,
    wjmJoinData :: [joinType]
}

-- let's use local to extend / extract? (not comonad)



getFromDB :: IO (AlreadyHKDEntity Identity)
getFromDB = pure (AlreadyHKDEntity (Identity "Hello") (Identity 42))

getFromDBWithJoinData :: IO (AlreadyHKDEntity WithJoinData)
getFromDBWithJoinData = pure undefined

-- now what do I actually want to do here

-- I want to use the functions from one direction in another

