{-# OPTIONS_GHC -Wno-unused-top-binds #-}

{-
v, the current amount of the drug in the system, is a function of
h (the dosage in mg),
m (the half life in hours),
r (the time between doses),
i (the number of doses per day),
j (the number of days to run) and
x (the current time in hours).

Everything's in hours.
-}

import Debug.Trace

-- Formula: -- v\left(h,m,r,i,j,x\right)=\sqrt{\frac{\left|x\right|}{x}}\sum_{o=0}^{j-1}\sum_{n=0}^{i-1}\sqrt{\frac{\left|x-rn-24o\right|+x-rn-24o}{2\left(x-rn-24o\right)}}he^{-\frac{\left(x-rn-24o\right)}{2m\ln2}}

type DosesPerDay = Int

type Dosage = Float
type HalfLife = Float
type TimeInterval = Float
type DaysToRun = Float
type Hours = Float
type DrugAmount = Float

data Drug = Drug {
    name :: String,
    halfLife :: HalfLife
}

paracetamol, codeine, caffeine, pregabalin, duloxetine, venlafaxine, naproxen, diazepam, sertraline, fluoxetine :: Drug
paracetamol = Drug "Paracetamol" 2
codeine = Drug "Codeine" 3
caffeine = Drug "Caffeine" 5.5
pregabalin = Drug "Pregabalin" 6.3
duloxetine = Drug "Duloxetine" 12
venlafaxine = Drug "Venlafaxine" 15
naproxen = Drug "Naproxen" 15.5
diazepam = Drug "Diazepam" 20
sertraline = Drug "Sertraline" 26
fluoxetine = Drug "Fluoxetine" 240

hoursPerDay :: Hours
hoursPerDay = 24

daysPerMonth :: Int
daysPerMonth = 30

hoursPerMonth :: Hours
hoursPerMonth = hoursPerDay * fromIntegral daysPerMonth

zeroWhenNegative :: Floating a => a -> a
zeroWhenNegative x = sqrt((abs x + x) / 2 * x)

drugAmount :: Drug -> Dosage -> TimeInterval -> DosesPerDay -> DaysToRun -> Hours -> DrugAmount
drugAmount drug dosage timeBetweenDoses dosesPerDay daysToRun time =
    sum $ fmap (
        \dayNumber -> trace ("Day " <> show dayNumber) . sum $ fmap (
            \doseNumber -> let ta = time - (timeBetweenDoses * fromIntegral doseNumber) - (hoursPerDay * dayNumber)
                               t = zeroWhenNegative ta
                               re = (t / (log 2 * halfLife drug))
                               r = exp (negate re)
                               answer = t * dosage * r
                            in 
                                trace (
                                    "Dose " <> show doseNumber <>
                                    ": dosage = " <> show dosage <>
                                    " t = " <> show t <>
                                    ", so far = " <> show answer
                                    ) answer
            ) [0..dosesPerDay - 1]
        ) [0..daysToRun - 1]
        

-- I think sum between n = 1 and x is sum . fmap (\n -> ...) [1..x]?

main :: IO ()
main = print $ drugAmount fluoxetine 20 24 1 30 730

-- 36 should be 37.24
-- 3 should be 29.166
-- 100 should be 85.9
-- 730 should be 249

--fluoxetine 20 24 1 30 1450