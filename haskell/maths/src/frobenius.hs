module Main (main) where

import Control.Error.Util (note)
import Data.Either
import Data.Either.Extra
import Frobenius
import System.Environment
import Text.Read

parseArgs ∷ [String] → [Either String Int]
parseArgs = fmap readEither

areArgsValid ∷ [Either String Int] → Bool
areArgsValid args = all isRight args && 2 == length args

validateArgs ∷ [Either String Int] → Either String [Int]
validateArgs xs = if areArgsValid xs then sequence xs else Left "Arguments not valid"

processArgs ∷ Either String [Int] → Either String Int
processArgs (Right [a, b]) = note "Numbers cannot be frobeniused!" $ frob a b
processArgs _              = Left "Can't process args!"

prog ∷ [String] → String
prog = fromEither . fmap show . processArgs . validateArgs . parseArgs

main ∷ IO ()
main = getArgs >>= putStrLn . prog
