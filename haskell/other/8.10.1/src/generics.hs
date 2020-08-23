module Main (main) where

data FourThings a = FT a a a a deriving (Show)

ft :: FourThings Int
ft = FT 1 2 3 4

ftc :: FourThings String
ftc = FT "a" "b" "c" "d"

oper :: (a -> a -> a) -> FourThings a -> FourThings a -> FourThings a
oper op (FT a b c d) (FT e f g h) = FT (op a e) (op b f) (op c g) (op d h)

main :: IO ()
main = print [ -- two shows not map - different data types
    show (oper (+) ft ( FT 5 6 7 8 )),
    show (oper (++) ftc ftc )]
