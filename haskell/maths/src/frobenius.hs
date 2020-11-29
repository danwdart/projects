{-# LANGUAGE UnicodeSyntax #-}
import           Data.Either
import           System.Environment
import           Text.Read

fromEither ∷ Either a a → a
fromEither (Left x)  = x
fromEither (Right y) = y

frob2 ∷ Int → Int → Either String Int
frob2 a b = if 1 == gcd a b then Right (frob2Real a b) else Left "Numbers cannot be frobeniused!"

frob2Real ∷ Int → Int → Int
frob2Real a b = a * b - a - b

parseArgs ∷ [String] → [Either String Int]
parseArgs = fmap readEither

areArgsValid ∷ [Either String Int] → Bool
areArgsValid args = all isRight args && 2 == length args

validateArgs ∷ [Either String Int] → Either String [Int]
validateArgs xs = if areArgsValid xs then sequence xs else Left "Arguments not valid"

processArgs ∷ Either String [Int] → Either String Int
processArgs (Right [a, b]) = frob2 a b
processArgs _              = Left "Can't process args!"

prog ∷ [String] → String
prog = fromEither . fmap show . processArgs . validateArgs . parseArgs

main ∷ IO ()
main = getArgs >>= putStrLn . prog
