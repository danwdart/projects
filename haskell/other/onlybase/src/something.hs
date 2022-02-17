{-# LANGUAGE UnicodeSyntax #-}
-- import           Control.Arrow
-- import           Control.Monad
-- import           Data.Char
-- import           Data.Functor
-- import           Data.List

-- a1 x = x <> (" " <> show (length x))

-- a2 :: String -> String
-- a2 = unwords . ap [id, show.length] . pure

-- a3 :: String -> String
-- a3 = pure >>> ap [id, show.length] >>> unwords

-- main1 :: IO String
-- main1 = getLine <&> fmap toUpper <&> words <&> intercalate "-" <&> replicate 2 <&> unwords <&> a2

main ∷ IO ()
main = pure ()
