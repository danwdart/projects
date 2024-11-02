{-# LANGUAGE DeriveAnyClass             #-}
{-# LANGUAGE DerivingVia                #-}
{-# LANGUAGE Trustworthy                #-}
{-# LANGUAGE UndecidableInstances       #-}
{-# OPTIONS_GHC -Wno-unsafe -Wwarn #-}

module Main (main) where

import Barbies
import Control.Applicative
import Control.Monad.IO.Class
import Data.Functor.Identity
import Data.Proxy
import GHC.Generics

newtype Name = Name {
    getName :: String
} deriving stock (Eq, Read, Show)

newtype Profession = Profession {
    getProfession :: String
} deriving stock (Eq, Read, Show)

newtype Age = Age Int deriving newtype (Eq, Read, Show)

newtype Level = Level Int deriving (Eq, Read, Show) via Int

data Person f = Person {
    name       :: f Name,
    profession :: f Profession
}
    deriving stock (Generic)
    deriving anyclass (FunctorB, TraversableB, ApplicativeB, ConstraintsB)

deriving instance AllBF Read f Person ⇒ Read (Person f)
deriving instance AllBF Show f Person ⇒ Show (Person f)
deriving instance AllBF Eq   f Person ⇒ Eq   (Person f)

myPerson ∷ Person Identity
myPerson = Person {
    name = Identity (Name "Dan"),
    profession = Identity (Profession "Coder")
}

myPossiblyPerson ∷ Person Maybe
myPossiblyPerson = Person {
    name = Just (Name "Bobbly Bob"),
    profession = Nothing
}

descriptions ∷ Person (Const String)
descriptions = Person {
    name = Const "The name of the person",
    profession = Const "The profession"
}

renderFields ∷ Person (Const String)
renderFields = Person {
    name = Const "Name: ",
    profession = Const "Profession: "
}

-- how do we do typed crud


newtype ModelId = ModelId String

data Operator a = Eq a | GT a | LT a | LTE a | In [a] | NotIn [a]

data Model m = Model {
    modelId     :: ModelId,
    modelFields :: m Identity,
    createdAt   :: String,
    updatedAt   :: Maybe String
}

class MonadDB monad model where
    create :: model Identity → monad (Model model)
    retrieveById :: ModelId → monad (Maybe (Model model))
    retrieveWhere :: model (Maybe :.: Operator) → monad [Model model]
    updateById :: ModelId → model Maybe → monad (Maybe (Model model))
    updateWhere :: model (Maybe :.: Operator) → model Maybe → monad [Model model]
    replaceById :: ModelId → model Identity → monad (Maybe (Model model))
    replaceWhere :: model (Maybe :.: Operator) → model Identity → monad [Model model]
    deleteById :: Proxy model → ModelId → monad Bool
    deleteWhere :: model (Maybe :.: Operator) → monad Bool

data MyModel f = MyModel {
    myModelName        :: f String,
    myModelInformation :: f Int
}

{-}
instance (MonadIO m, Show (model Identity), Show ((:.:) model Operator)) => MonadDB m model where
    create model = do
        liftIO . putStrLn $ "Creating" <> show model
        pure $ Model (ModelId "123") model "Now" Nothing
    retrieveById id = do
        liftIO . putStrLn $ "Retrieving" <> show id
        pure . Just $ Model (ModelId "123") undefined "Now" Nothing
    retrieveWhere fields = do
        liftIO . putStrLn $ "Retrieving" <> show fields
        pure [ Model (ModelId "123") undefined "Now" Nothing ]
    updateById id updateModel = undefined
    updateWhere = undefined
    replaceById = undefined
    replaceWhere = undefined
    deleteById = undefined
    deleteWhere = undefined
-}

{-}

data FakeDBT m a = FakeDBT m a
    deriving (Functor, Applicative, Monad)

-}

-- deriving instance MonadTrans FakeDBT

-- type FakeDB a = FakeDBT Identity a



-- hkd maps? are they useful?
-- hkd ((->) something) - get a single field type

-- personConvertor :: Person ((->) Bool) ???

main ∷ IO ()
main = do
    print myPerson
    print myPossiblyPerson
    print descriptions
    print renderFields
