{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main (main) where

import Data.DisparateList

data BoolOrIntG a where
    BoolG :: BoolOrIntG Bool
    IntG :: BoolOrIntG Int

deriving stock instance Show (BoolOrIntG a)

data BoolOrIntA a
    = BoolA (Bool -> a)
    | IntA (Int -> a)

instance Show (BoolOrIntA a) where
    show (BoolA _) = "BoolA"
    show (IntA _) = "IntA"

extBIG ∷ BoolOrIntG a → a
extBIG BoolG = False
extBIG IntG  = 0

extBIA :: BoolOrIntA a -> a
extBIA (BoolA f) = f False
extBIA (IntA f) = f 0

data ArrowG a b where
    FnG :: (a → b) -> ArrowG a b
    CompG :: ArrowG b c -> ArrowG a b -> ArrowG a c

-- ??? something like that...
data ArrowA a b
    = forall c. FnA (a -> b) (c -> b) (a -> c)
    | forall c d. CompA (ArrowA b c) (ArrowA a b) (d -> c) (a -> d) -- where rbc and rab are something to be determined

evalG ∷ ArrowG a b → a → b
evalG (FnG f') x     = f' x
evalG (CompG f' g) x = evalG f' (evalG g x)

evalA :: ArrowA a b -> a -> b
evalA (FnA f' _ _) x = f' x
evalA (CompA _ _ _ _) _ = undefined

numG ∷ ArrowG a b → Int
numG (FnG _)      = 0
numG (CompG f' g) = 1 + numG f' + numG g

numA :: ArrowA a b -> Int
numA (FnA _ _ _) = 0
numA (CompA f' g' _ _) = 1 + numA f' + numA g'

hmmG ∷ Enum a ⇒ ArrowG a a
hmmG = CompG (CompG (FnG succ) (FnG succ)) (CompG (FnG succ) (FnG succ))

hmmA :: ArrowA a a
hmmA = undefined -- CompA (CompA (FnA succ) (FnA succ)) (CompA (FnA succ) (FnA succ))

idsG ∷ ArrowG a a
idsG = CompG (CompG (FnG id) (FnG id)) (CompG (FnG id) (FnG id))
-- deriving instance (Show a, Show (L t)) => Show (L (a ': t))

idsA ∷ ArrowA a a
idsA = undefined -- CompA (CompA (FnA id) (FnA id)) (CompA (FnA id) (FnA id))
-- deriving instance (Show a, Show (L t)) => Show (L (a ': t))

main ∷ IO ()
main = do
    print $ extBIG BoolG
    print $ extBIG IntG

    print ((2::Int) :> "a" :> Nil)
    print Nil
    
    print $ evalG hmmG (1::Int)
    print $ numG idsG

    print $ extBIA $ BoolA id
    print $ extBIA $ IntA id
    
    -- print $ evalA hmmA (1::Int)
    -- print $ numA idsA
