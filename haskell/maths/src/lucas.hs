{-# OPTIONS_GHC -Wno-unused-matches -Wno-unused-top-binds #-}

main :: IO ()
main = return ()

phi :: Double
phi = (sqrt 5 + 1) / 2

iphi :: Double
iphi = -(sqrt 5 - 1) / 2

powphicaret :: Integer -> Integer
powphicaret n = round (phi ^ n)

powphiiphicaret :: Integer -> Integer
powphiiphicaret n = round (phi ^ n - iphi ^ n)

powphistarstar :: Integer -> Integer
powphistarstar n = round (phi ** fromInteger n)

powphiiphistarstar :: Integer -> Integer
powphiiphistarstar n = round (phi ** fromInteger n - iphi ** fromInteger n)

lucas :: Integer -> Integer
lucas n = undefined