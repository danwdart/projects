{-# LANGUAGE UnicodeSyntax #-}
{-
import Data.Biapplicative

data Model a b = Model a b

instance (Show a, Show b) => Show (Model a b) where
    show (Model a b) = "Model " ++ a ++ " " ++ b

-- instance Bifunctor Model where

-- instance Biapplicative Model
--     bipure = Model

defModelTransformer :: Model (a -> a) (b -> b)
defModelTransformer = Model id id

defModel :: Model String Int
defModel = Model "String" 1

tr :: Model (String -> String) (Int -> Int)
tr = Model (++"!") (+1)

tModel :: Model String Int
tModel = tr <<*>> defModel

main = print tModel
-}

main ∷ IO ()
main = pure ()
