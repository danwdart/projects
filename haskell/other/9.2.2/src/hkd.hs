{-# LANGUAGE DeriveAnyClass       #-}
{-# LANGUAGE DeriveGeneric        #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE StandaloneDeriving   #-}
{-# LANGUAGE UnicodeSyntax        #-}

{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -Wwarn #-}

import           Barbies
import           Control.Applicative
import           Data.Functor.Identity
import           GHC.Generics

newtype Name = Name String deriving (Eq, Read, Show)

newtype Profession = Profession String deriving (Eq, Read, Show)

data Person f = Person {
    name       :: f Name,
    profession :: f Profession
} deriving (Generic, FunctorB, TraversableB, ApplicativeB, ConstraintsB)

deriving instance AllBF Read f Person ⇒ Read (Person f)
deriving instance AllBF Show f Person ⇒ Show (Person f)
deriving instance AllBF Eq   f Person ⇒ Eq   (Person f)

c ∷ Const String Int
c = Const "1"

i ∷ Identity Int
i = Identity . read . getConst $ c

personRaw ∷ Person (Const String)
personRaw = Person {
    name = Const "Bob",
    profession = Const "Coder"
}

personContainer ∷ Container Person String
personContainer = Container personRaw

main ∷ IO ()
main = do
    print personRaw
