{-# LANGUAGE UnicodeSyntax #-}
-- import Data.Traversable

type Name = String

data Expr = Var Name
    | Lam Name Expr
    | App Expr Expr

instance Show Expr where
    show (Var v)     = v
    show (Lam n e)   = "\\" ++ n ++ "." ++ show e
    show (App e1 e2) = "(" ++ show e1 ++ " " ++ show e2 ++ ")"

-- apply

compose ∷ Expr
compose = Lam "a" (Lam "b" (Lam "c" (App ( App (Var "a") (Var "b")) (Var "c"))))

main ∷ IO ()
main = print compose
