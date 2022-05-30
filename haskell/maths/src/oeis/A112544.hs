{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import           NumList

-- A112544
bigList ∷ [Int]
bigList = concatMap toNumList [2..20]

triangleList ∷ String
triangleList = unlines . fmap show $ (toNumList <$> [2..40])
-- END A112544

main ∷ IO ()
main = putStrLn triangleList
