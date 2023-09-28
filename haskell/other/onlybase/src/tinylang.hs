-- Functional

import GHC.Read
import Text.Read
import Text.Read.Lex

data Program = Void | Val Int

instance Read Program where
    readPrec = do
        lex' <- lexP
        case lex' of
            Number a -> case numberToInteger a of
                Just n  -> pure $ Val (fromInteger n)
                Nothing -> pure Void
            _ -> pure Void

interpretAST ∷ Program → IO ()
interpretAST Void    = putStrLn "Encountered Void"
interpretAST (Val x) = putStrLn $ "Encountered Val: " <> show x

program ∷ String
program = "1"

interpret ∷ String → IO ()
interpret program' = do
    putStrLn "Interpreting"
    let programAST = read program' :: Program
    interpretAST programAST

main ∷ IO ()
main = interpret program
