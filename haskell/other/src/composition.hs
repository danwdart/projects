{- # LANGUAGE TemplateHaskell #
import Language.Haskell.TH
import Lib.TH

stringifyType :: Name -> String
stringifyType n = filterOK $(reify n >>= infoToExp)

main :: IO ()
main = putStrLn stringifyType '(.)
-}

main :: IO ()
main = return ()