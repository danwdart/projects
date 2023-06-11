{-# LANGUAGE GADTs                 #-}
{-# LANGUAGE OverloadedLists       #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuantifiedConstraints #-}
{-# LANGUAGE Unsafe                #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Data.Function.Free.Abstract where

import Control.Category
import Control.Category.Cartesian
import Control.Category.Choice
import Control.Category.Cocartesian
-- import Control.Category.Cochoice
-- import Control.Category.Costrong
import Control.Category.Interpret
import Control.Category.Numeric
import Control.Category.Strong
-- import Control.Category.Primitive.Abstract
import Control.Category.Primitive.Interpret
import Data.Aeson
import Prelude                              hiding (id, (.))

data FreeFunc p a b where
    Id :: FreeFunc p x x
    Compose :: FreeFunc p y z -> FreeFunc p x y -> FreeFunc p x z
    Copy :: FreeFunc p x (x, x)
    Consume :: FreeFunc p x ()
    First :: FreeFunc p a b -> FreeFunc p (a, x) (b, x)
    Second :: FreeFunc p a b -> FreeFunc p (x, a) (x, b)
    {- Unfirst :: FreeFunc p (a, x) (b, x) -> FreeFunc p a b -}
    Fst :: FreeFunc p (a, b) a
    Snd :: FreeFunc p (a, b) b
    InjectL :: FreeFunc p a (Either a b)
    InjectR :: FreeFunc p a (Either b a)
    Left' :: FreeFunc p a b -> FreeFunc p (Either a x) (Either b x)
    Right' :: FreeFunc p a b -> FreeFunc p (Either x a) (Either x b)
    {- Unleft :: FreeFunc p (Either a x) (Either b x) -> FreeFunc p a b -}
    Unify :: FreeFunc p (Either a a) a
    Tag :: FreeFunc p (Bool, a) (Either a a)
    Num :: Int -> FreeFunc p a Int
    Negate :: FreeFunc p Int Int
    Add :: FreeFunc p (Int, Int) Int
    Mult :: FreeFunc p (Int, Int) Int
    Div :: FreeFunc p (Int, Int) Int
    Mod :: FreeFunc p (Int, Int) Int
    Lift :: p a b -> FreeFunc p a b

deriving instance (forall a b. Show (p a b)) ⇒ Show (FreeFunc p x y)

-- deriving instance (forall a b. Read (p a b)) => Read (FreeFunc p x y)

instance (Numeric cat, Cocartesian cat, {- Cochoice cat,-} Choice cat, Cartesian cat, {- Costrong cat, -} Strong cat, Category cat, InterpretPrim p cat) ⇒ Interpret (FreeFunc p) cat where
    {-# INLINABLE interpret #-}
    interpret Id            = id
    interpret (Compose a b) = interpret a . interpret b
    interpret Copy          = copy
    interpret Consume       = consume
    interpret (First a)     = first' (interpret a)
    interpret (Second a)    = second' (interpret a)
    {- interpret (Unfirst a)   = unfirst (interpret a) -}
    interpret Fst           = fst'
    interpret Snd           = snd'
    interpret InjectL       = injectL
    interpret InjectR       = injectR
    interpret (Left' a)     = left' (interpret a)
    interpret (Right' a)    = right' (interpret a)
    {- interpret (Unleft a)    = unleft (interpret a) -}
    interpret Unify         = unify
    interpret Tag           = tag
    interpret (Num n)       = num n
    interpret Negate        = negate'
    interpret Add           = add
    interpret Mult          = mult
    interpret Div           = div'
    interpret Mod           = mod'
    interpret (Lift a)      = interpretPrim a

instance (forall a b. ToJSON (k a b)) ⇒ ToJSON (FreeFunc k x y) where
    toJSON Id = String "Id"
    toJSON (Compose f g) = object [ "type" .= String "Compose", "args" .= Array [ toJSON f, toJSON g ] ]
    toJSON Copy = String "Copy"
    toJSON Consume = String "Consume"
    toJSON (First f) = object [ "type" .= String "First", "args" .= Array [ toJSON f ] ]
    toJSON (Second f) = object [ "type" .= String "Second", "args" .= Array [ toJSON f ] ]
    {- toJSON (Unfirst f) = object [ "type" .= String "Unfirst", "args" .= Array [ toJSON f ] ] -}
    toJSON Fst = String "Fst"
    toJSON Snd = String "Snd"
    toJSON InjectL = String "InjectL"
    toJSON InjectR = String "InjectR"
    toJSON (Left' f) = object [ "type" .= String "Left'", "args" .= Array [ toJSON f ] ]
    toJSON (Right' f) = object [ "type" .= String "Right'", "args" .= Array [ toJSON f ] ]
    {- toJSON (Unleft f) = object [ "type" .= String "Unleft'", "args" .= Array [ toJSON f ] ] -}
    toJSON Unify = String "Unify"
    toJSON Tag = String "Tag"
    toJSON (Num n) = object [ "type" .= String "Num", "args" .= Array [ toJSON n ] ]
    toJSON Negate = String "Negate"
    toJSON Add = String "Add"
    toJSON Mult = String "Add"
    toJSON Div = String "Div"
    toJSON Mod = String "Mod"
    toJSON (Lift f) = object [ "type" .= String "Lift", "args" .= Array [ toJSON f ] ]

instance FromJSON (FreeFunc p a a) where
    parseJSON (String "Id") = pure Id
    parseJSON _             = fail "TypeError: expecting a -> a"

instance Category (FreeFunc p) where
    id = Id
    (.) = Compose

instance Cartesian (FreeFunc p) where
    copy = Copy
    consume = Consume
    fst' = Fst
    snd' = Snd

instance Strong (FreeFunc p) where
    first' = First
    second' = Second

{-}
instance Costrong (FreeFunc p) where
    unfirst = Unfirst
-}

instance Cocartesian (FreeFunc p) where
    injectL = InjectL
    injectR = InjectR
    unify = Unify
    tag = Tag

instance Choice (FreeFunc p) where
    left' = Left'
    right' = Right'

{-}
instance Cochoice (FreeFunc p) where
    unleft = Unleft
-}

-- instance Symmetric (FreeFunc p) where

instance Numeric (FreeFunc p) where
    num = Num
    negate' = Negate
    add = Add
    mult = Mult
    div' = Div
    mod' = Mod
